using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// Player controller with color-matching mechanics and fading.
/// Player fades when NOT on matching-color platforms.
/// UPDATED: Unity 2021+ compatible - uses FindFirstObjectByType instead of deprecated FindObjectOfType
/// </summary>
[RequireComponent(typeof(CharacterController))]
public class PlayerController : MonoBehaviour
{
    [Header("Player Settings")]
    public GameColor playerColor = GameColor.Blue;
    public float fadeRate = 0.5f;
    public float pushForce = 5.0f;

    [Header("Movement")]
    public float speed = 5.0f;
    public float jumpVelocity = 9.0f;
    public float gravity = 20.0f;

    [Header("Ball Settings")]
    public float ballRadius = 0.5f;
    public Transform visualMeshParent; // Parent of all visual meshes

    private CharacterController controller;
    private Vector3 velocity;
    private bool wasOnGround;
    private float pushCooldown;
    private const float PUSH_INTERVAL = 0.5f;
    private const float FADE_DELAY = 2.0f;

    private List<MeshRenderer> visualMeshes = new List<MeshRenderer>();
    private bool isOnMatchingPlatform = false;
    private Dictionary<int, float> collisionTimers = new Dictionary<int, float>();

    // Color definitions
    private static readonly Dictionary<GameColor, Color> NEON_COLORS = new Dictionary<GameColor, Color>
    {
        { GameColor.Blue, new Color(0.0f, 0.5f, 1.0f) },
        { GameColor.Green, new Color(0.2f, 0.8f, 0.2f) },
        { GameColor.Red, new Color(1.0f, 0.2f, 0.2f) },
        { GameColor.Purple, new Color(0.6f, 0.2f, 0.8f) },
        { GameColor.Orange, new Color(1.0f, 0.6f, 0.0f) },
        { GameColor.Gold, new Color(1.0f, 0.84f, 0.0f) }
    };

    void Start()
    {
        controller = GetComponent<CharacterController>();

        // Find all visual meshes
        if (visualMeshParent != null)
        {
            FindMeshesRecursive(visualMeshParent);
        }
        else
        {
            FindMeshesRecursive(transform);
        }

        // Initialize materials for fading
        foreach (var meshRenderer in visualMeshes)
        {
            Material[] materials = meshRenderer.materials;
            for (int i = 0; i < materials.Length; i++)
            {
                Material mat = materials[i];
                // Enable transparency using standard shader
                if (mat.HasProperty("_Mode"))
                {
                    mat.SetFloat("_Mode", 3); // Transparent mode
                    mat.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                    mat.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    mat.SetInt("_ZWrite", 0);
                    mat.DisableKeyword("_ALPHATEST_ON");
                    mat.EnableKeyword("_ALPHABLEND_ON");
                    mat.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                    mat.renderQueue = 3000;
                }
            }
        }

        UpdateColorMaterial(playerColor);
    }

    void FindMeshesRecursive(Transform parent)
    {
        MeshRenderer meshRenderer = parent.GetComponent<MeshRenderer>();
        if (meshRenderer != null)
        {
            visualMeshes.Add(meshRenderer);
        }

        foreach (Transform child in parent)
        {
            FindMeshesRecursive(child);
        }
    }

    void Update()
    {
        // Handle fading
        if (visualMeshes.Count > 0)
        {
            Color currentColor = visualMeshes[0].material.color;
            float currentAlpha = currentColor.a;
            float targetAlpha = isOnMatchingPlatform ? 1.0f : 0.0f;

            float newAlpha = Mathf.MoveTowards(currentAlpha, targetAlpha, fadeRate * Time.deltaTime);

            // Apply to all visual meshes
            foreach (var meshRenderer in visualMeshes)
            {
                Material[] materials = meshRenderer.materials;
                foreach (var mat in materials)
                {
                    Color col = mat.color;
                    col.a = newAlpha;
                    mat.color = col;

                    // Update emission if enabled
                    if (mat.HasProperty("_EmissionColor"))
                    {
                        Color emissionColor = mat.GetColor("_EmissionColor");
                        mat.SetColor("_EmissionColor", emissionColor * (newAlpha * 2.0f));
                    }
                }
            }

            // Game Over if faded completely
            if (newAlpha <= 0.0f)
            {
                GameOver();
            }
        }
    }

    void FixedUpdate()
    {
        // Gravity
        if (!controller.isGrounded)
        {
            velocity.y -= gravity * Time.fixedDeltaTime;
        }
        else
        {
            velocity.y = -2f; // Small downward force to keep grounded
        }

        // Push cooldown
        if (pushCooldown > 0)
        {
            pushCooldown -= Time.fixedDeltaTime;
        }

        // Jump
        if (Input.GetButtonDown("Jump") && controller.isGrounded)
        {
            velocity.y = jumpVelocity;
            if (AudioManager.Instance != null)
            {
                AudioManager.Instance.PlaySfx("jump");
            }
        }

        // Horizontal movement
        float horizontal = Input.GetAxis("Horizontal");
        velocity.x = horizontal * speed;
        velocity.z = 0; // Lock Z-axis for 2.5D gameplay

        // Move
        controller.Move(velocity * Time.fixedDeltaTime);

        // Rotate meshes to simulate ball rolling
        if (velocity.x != 0 && visualMeshParent != null)
        {
            float rotAmount = (-velocity.x / ballRadius) * Time.fixedDeltaTime * Mathf.Rad2Deg;
            visualMeshParent.Rotate(0, 0, rotAmount);
        }

        // Landing sound
        if (!wasOnGround && controller.isGrounded)
        {
            if (AudioManager.Instance != null)
            {
                AudioManager.Instance.PlaySfx("land");
            }
        }
        wasOnGround = controller.isGrounded;

        // Fall detection
        if (transform.position.y < -10f)
        {
            GameOver();
        }

        // Platform interaction
        CheckPlatformCollisions();
    }

    void CheckPlatformCollisions()
    {
        isOnMatchingPlatform = false;

        // Raycast downward to detect platforms
        RaycastHit hit;
        if (Physics.Raycast(transform.position, Vector3.down, out hit, 1.5f))
        {
            PlatformController platform = hit.collider.GetComponent<PlatformController>();
            if (platform != null)
            {
                if (platform.platformColor == playerColor)
                {
                    isOnMatchingPlatform = true;

                    int objId = platform.GetInstanceID();
                    if (!collisionTimers.ContainsKey(objId))
                    {
                        collisionTimers[objId] = 0f;
                    }

                    collisionTimers[objId] += Time.fixedDeltaTime;

                    // Start fading platform after delay
                    if (collisionTimers[objId] >= FADE_DELAY)
                    {
                        platform.StartFading(Time.fixedDeltaTime);
                    }
                }
            }
        }
    }

    void OnControllerColliderHit(ControllerColliderHit hit)
    {
        // Check for box collision
        BoxController box = hit.collider.GetComponent<BoxController>();
        if (box != null && box.boxColor == playerColor)
        {
            // Push the box
            Rigidbody boxRb = box.GetComponent<Rigidbody>();
            if (boxRb != null)
            {
                Vector3 pushDir = hit.moveDirection;
                pushDir.y = 0;
                pushDir.Normalize();
                boxRb.AddForce(pushDir * pushForce, ForceMode.Impulse);

                if (pushCooldown <= 0)
                {
                    if (AudioManager.Instance != null)
                    {
                        AudioManager.Instance.PlaySfx("push");
                    }
                    pushCooldown = PUSH_INTERVAL;
                }
            }
        }
    }

    public void ChangeColor(GameColor newColor)
    {
        playerColor = newColor;

        // Reset alpha immediately
        foreach (var meshRenderer in visualMeshes)
        {
            Material[] materials = meshRenderer.materials;
            foreach (var mat in materials)
            {
                Color col = mat.color;
                col.a = 1.0f;
                mat.color = col;
            }
        }

        UpdateColorMaterial(newColor);

        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlaySfx("change_color");
        }
    }

    void UpdateColorMaterial(GameColor color)
    {
        Color targetColor = NEON_COLORS.ContainsKey(color) ? NEON_COLORS[color] : Color.white;

        // Apply to ColorIdentifier mesh
        foreach (var meshRenderer in visualMeshes)
        {
            if (meshRenderer.name == "ColorIdentifier")
            {
                Material mat = meshRenderer.material;
                mat.color = targetColor;
                
                if (mat.HasProperty("_EmissionColor"))
                {
                    mat.EnableKeyword("_EMISSION");
                    mat.SetColor("_EmissionColor", targetColor * 0.0f); // No glow initially
                }
            }
        }
    }

    void GameOver()
    {
        // Use FindFirstObjectByType for Unity 2021.3+
        #if UNITY_2023_1_OR_NEWER
        GameUIManager uiManager = FindFirstObjectByType<GameUIManager>();
        #else
        GameUIManager uiManager = FindObjectOfType<GameUIManager>();
        #endif
        
        if (uiManager != null)
        {
            uiManager.GameOver();
        }

        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlaySfx("lose");
        }

        enabled = false;
    }
}
