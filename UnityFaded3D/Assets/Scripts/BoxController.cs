using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// Box controller with color-based interaction.
/// Only same-color players can push boxes.
/// </summary>
[RequireComponent(typeof(Rigidbody))]
public class BoxController : MonoBehaviour
{
    public GameColor boxColor = GameColor.Blue;

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
        Color targetColor = NEON_COLORS.ContainsKey(boxColor) ? NEON_COLORS[boxColor] : Color.white;

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
                    mat.SetColor("_EmissionColor", targetColor * 0.0f); // No glow
                }
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
                color.a = Mathf.MoveTowards(color.a, 0.0f, 0.5f * deltaTime);
                mat.color = color;

                if (mat.HasProperty("_EmissionColor"))
                {
                    Color emission = mat.GetColor("_EmissionColor");
                    mat.SetColor("_EmissionColor", emission * (color.a * 2.0f));
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
