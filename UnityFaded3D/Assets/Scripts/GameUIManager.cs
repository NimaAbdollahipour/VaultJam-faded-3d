using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

/// <summary>
/// Manages game UI including Win, Lose, and Pause panels.
/// UPDATED: Unity 2021+ compatible
/// </summary>
public class GameUIManager : MonoBehaviour
{
    [Header("UI Panels")]
    public GameObject winPanel;
    public GameObject losePanel;
    public GameObject pausePanel;

    [Header("Buttons")]
    public Button resumeButton;
    public Button retryButton;
    public Button quitButton;
    public Button continueButton;

    private bool isPaused = false;

    void Start()
    {
        // Hide all panels at start
        if (winPanel != null) winPanel.SetActive(false);
        if (losePanel != null) losePanel.SetActive(false);
        if (pausePanel != null) pausePanel.SetActive(false);

        // Stop music during gameplay (game music handled by LevelController)
        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.StopMusic();
        }

        // Setup button listeners
        if (resumeButton != null) resumeButton.onClick.AddListener(OnResumePressed);
        if (retryButton != null) retryButton.onClick.AddListener(OnRetryPressed);
        if (quitButton != null) quitButton.onClick.AddListener(OnQuitPressed);
        if (continueButton != null) continueButton.onClick.AddListener(OnContinuePressed);
    }

    void Update()
    {
        // Toggle pause with Escape key
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if (winPanel != null && losePanel != null && !winPanel.activeSelf && !losePanel.activeSelf)
            {
                TogglePause();
            }
        }
    }

    void TogglePause()
    {
        isPaused = !isPaused;

        if (isPaused)
        {
            if (pausePanel != null) pausePanel.SetActive(true);
            Time.timeScale = 0f;
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
        }
        else
        {
            if (pausePanel != null) pausePanel.SetActive(false);
            Time.timeScale = 1f;
        }
    }

    public void GameOver()
    {
        if ((winPanel != null && winPanel.activeSelf) || (losePanel != null && losePanel.activeSelf))
            return;

        if (losePanel != null) losePanel.SetActive(true);
        Time.timeScale = 0f;
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;

        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlayGameMusic();
        }
    }

    public void LevelComplete()
    {
        if ((winPanel != null && winPanel.activeSelf) || (losePanel != null && losePanel.activeSelf))
            return;

        if (winPanel != null) winPanel.SetActive(true);
        Time.timeScale = 0f;
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;

        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlayGameMusic();
        }
    }

    void OnResumePressed()
    {
        TogglePause();
    }

    void OnRetryPressed()
    {
        Time.timeScale = 1f;
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    void OnQuitPressed()
    {
        Time.timeScale = 1f;
        Application.Quit();
        
        #if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
        #endif
    }

    void OnContinuePressed()
    {
        Time.timeScale = 1f;

        // Get current scene name and determine next level
        string currentScene = SceneManager.GetActiveScene().name;
        string nextLevel = "";

        if (currentScene.Contains("Level1"))
        {
            nextLevel = "Level2";
        }
        // Add more level progressions as needed

        if (!string.IsNullOrEmpty(nextLevel))
        {
            // Save progress
            if (SaveManager.Instance != null)
            {
                SaveManager.Instance.SaveGame(nextLevel);
            }

            SceneManager.LoadScene(nextLevel);
        }
        else
        {
            // End of game, return to menu
            SceneManager.LoadScene("StartMenu");
        }
    }
}
