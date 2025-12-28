using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

/// <summary>
/// Game Over screen controller.
/// Separate scene that loads after player loses.
/// </summary>
public class GameOverController : MonoBehaviour
{
    [Header("UI Elements")]
    public Button retryButton;
    public Button mainMenuButton;
    public Button quitButton;

    private string lastLevel = "Level1"; // Default

    void Start()
    {
        // Get the level that was just played
        if (SaveManager.Instance != null)
        {
            lastLevel = SaveManager.Instance.currentLevelPath;
        }

        // Setup button listeners
        if (retryButton != null) retryButton.onClick.AddListener(OnRetryPressed);
        if (mainMenuButton != null) mainMenuButton.onClick.AddListener(OnMainMenuPressed);
        if (quitButton != null) quitButton.onClick.AddListener(OnQuitPressed);

        // Play lose sound
        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlaySfx("lose");
            AudioManager.Instance.PlayMenuMusic(); // Background music
        }

        // Show cursor
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
    }

    void OnRetryPressed()
    {
        // Reload the level that was just played
        SceneManager.LoadScene(lastLevel);
    }

    void OnMainMenuPressed()
    {
        SceneManager.LoadScene("StartMenu");
    }

    void OnQuitPressed()
    {
        Application.Quit();
        
        #if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
        #endif
    }
}
