using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// Platform controller with color-matching and fading mechanics.
/// Platforms fade when matching-color player stands on them.
/// </summary>
public class PlatformController : MonoBehaviour
{
    public GameColor platformColor = GameColor.Blue;
    public FadeMode fadeMode = FadeMode.WhenStanding;
    public float fadeRate = 1.0f;

    private List<MeshRenderer> visualMeshes = new List<MeshRenderer>();

    private static readonly Dictionary<GameColor, Color> NEON_COLORS = new Dictionary<GameColor, Color>
    {
        { GameColor.Blue, new Color(0.0f, 0.5f, 1.0f) },
        { GameColor.Green, new Color(0.2f, 0.8f, 0.2f) },
        { GameColor.Red, new Color(1.0f, 0.2f, 0.2f) },
        { GameColor.Purple, new Color(0.6f, 0.2f, 0.8f) },
        { GameColor.Orange, new Color(1.0f, 0.6f, 0.0f) },
        { GameColor.Gold, new Color(1.0f, 0.84f, 0.0f) }
    };

    public enum FadeMode
    {
        WhenStanding,
        Always
    }

    void Start()
    {
        // Find all mesh renderers
        FindMeshesRecursive(transform);

        // Initialize materials for transparency
        foreach (var meshRenderer in visualMeshes)
        {
            Material[] materials = meshRenderer.materials;
            for (int i = 0; i < materials.Length; i++)
            {
                Material mat = materials[i];
                // Enable transparency
                if (mat.HasProperty("_Mode"))
                {
                    mat.SetFloat("_Mode", 3);
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

        UpdateVisuals();
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

    void UpdateVisuals()
    {
        Color targetColor = NEON_COLORS.ContainsKey(platformColor) ? NEON_COLORS[platformColor] : Color.white;

        foreach (var meshRenderer in visualMeshes)
        {
            Material mat = meshRenderer.material;

            // Apply color tint
            Color colorWithAlpha = targetColor;
            colorWithAlpha.a = 1.0f;
            mat.color = colorWithAlpha;

            // Setup emission
            if (mat.HasProperty("_EmissionColor"))
            {
                mat.EnableKeyword("_EMISSION");
                mat.SetColor("_EmissionColor", targetColor * 0.0f); // No glow initially
            }
        }
    }

    public void StartFading(float deltaTime)
    {
        bool fullyFaded = true;

        foreach (var meshRenderer in visualMeshes)
        {
            Material[] materials = meshRenderer.materials;
            foreach (var mat in materials)
            {
                Color color = mat.color;
                color.a = Mathf.MoveTowards(color.a, 0.0f, fadeRate * deltaTime);
                mat.color = color;

                if (mat.HasProperty("_EmissionColor"))
                {
                    Color emission = mat.GetColor("_EmissionColor");
                    mat.SetColor("_EmissionColor", emission * color.a);
                }

                if (color.a > 0.0f)
                {
                    fullyFaded = false;
                }
            }
        }

        if (fullyFaded)
        {
            Destroy(gameObject);
        }
    }
}
