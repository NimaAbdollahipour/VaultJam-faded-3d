using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

/// <summary>
/// Start menu controller with Play, Continue, and Quit buttons.
/// </summary>
public class StartMenuController : MonoBehaviour
{
    [Header("UI Elements")]
    public Button playButton;
    public Button continueButton;
    public Button quitButton;

    void Start()
    {
        // Setup button listeners
        if (playButton != null) playButton.onClick.AddListener(OnPlayPressed);
        if (continueButton != null) continueButton.onClick.AddListener(OnContinuePressed);
        if (quitButton != null) quitButton.onClick.AddListener(OnQuitPressed);

        // Check if there's a save file
        if (SaveManager.Instance != null && continueButton != null)
        {
            continueButton.interactable = SaveManager.Instance.HasSave();
        }

        // Play menu music
        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlayMenuMusic();
        }
    }

    void OnPlayPressed()
    {
        // New Game - clear save
        if (SaveManager.Instance != null)
        {
            SaveManager.Instance.ClearSave();
        }

        SceneManager.LoadScene("Level1");
    }

    void OnContinuePressed()
    {
        // Continue from saved game
        if (SaveManager.Instance != null)
        {
            SaveManager.Instance.LoadGame();
            string levelToLoad = SaveManager.Instance.currentLevelPath;

            if (!string.IsNullOrEmpty(levelToLoad))
            {
                SceneManager.LoadScene(levelToLoad);
            }
        }
    }

    void OnQuitPressed()
    {
        Application.Quit();
        
        #if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
        #endif
    }
}
