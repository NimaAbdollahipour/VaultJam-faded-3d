using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// Color switcher that changes player color on collision.
/// </summary>
public class ColorSwitcher : MonoBehaviour
{
    public GameColor switcherColor = GameColor.Blue;
    public float highlightIntensity = 5.0f;

    private Light highlightLight;
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

    void Start()
    {
        // Find highlight light
        highlightLight = GetComponentInChildren<Light>();

        // Find all mesh renderers
        FindMeshesRecursive(transform);

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
        Color targetColor = NEON_COLORS.ContainsKey(switcherColor) ? NEON_COLORS[switcherColor] : Color.white;

        // Update light
        if (highlightLight != null)
        {
            highlightLight.color = targetColor;
            highlightLight.intensity = highlightIntensity;
        }

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
                    mat.SetColor("_EmissionColor", targetColor * 0.0f);
                }
            }
        }
    }

    void OnTriggerEnter(Collider other)
    {
        PlayerController player = other.GetComponent<PlayerController>();
        if (player != null)
        {
            player.ChangeColor(switcherColor);
        }
    }
}
