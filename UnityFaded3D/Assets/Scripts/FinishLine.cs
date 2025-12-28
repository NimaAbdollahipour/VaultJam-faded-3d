using UnityEngine;

/// <summary>
/// Finish line trigger that completes the level.
/// </summary>
public class FinishLine : MonoBehaviour
{
    void OnTriggerEnter(Collider other)
    {
        // Check if player entered
        PlayerController player = other.GetComponent<PlayerController>();
        if (player != null)
        {
            LevelComplete();
        }
    }

    void LevelComplete()
    {
        // Use FindFirstObjectByType for Unity 2021.3+
        #if UNITY_2023_1_OR_NEWER
        GameUIManager uiManager = Object.FindFirstObjectByType<GameUIManager>();
        #else
        GameUIManager uiManager = Object.FindObjectOfType<GameUIManager>();
        #endif
        
        if (uiManager != null)
        {
            uiManager.LevelComplete();
        }

        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlaySfx("win");
        }
    }
}
