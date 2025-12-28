using UnityEngine;

/// <summary>
/// Level controller - initializes level and manages level-specific logic.
/// </summary>
public class LevelController : MonoBehaviour
{
    void Start()
    {
        // Start game music when level loads
        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlayGameMusic();
            Debug.Log("[Level] Game music started");
        }
    }
}
