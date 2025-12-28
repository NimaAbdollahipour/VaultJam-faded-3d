using UnityEngine;
using UnityEngine.SceneManagement;

/// <summary>
/// Simple level manager for gameplay scenes.
/// No UI panels - uses scene transitions for Win/Lose states.
/// </summary>
public class LevelManager : MonoBehaviour
{
    void Start()
    {
        // Start game music when level loads
        if (AudioManager.Instance != null)
        {
            AudioManager.Instance.PlayGameMusic();
            Debug.Log("[LevelManager] Game music started");
        }
    }

    void Update()
    {
        // Pause functionality can show a simple pause overlay
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            PauseGame();
        }
    }

    public void GameOver()
    {
        // Transition to GameOver scene
        Time.timeScale = 1f; // Reset time scale before loading
        SceneManager.LoadScene("GameOver");
    }

    public void LevelComplete()
    {
        // Save current level for progression
        string currentScene = SceneManager.GetActiveScene().name;
        
        // Determine next level
        string nextLevel = "";
        if (currentScene == "Level1")
        {
            nextLevel = "Level2";
        }
        else if (currentScene == "Level2")
        {
            nextLevel = "Level3"; // Add more levels as needed
        }

        // Save progress
        if (SaveManager.Instance != null)
        {
            SaveManager.Instance.SaveGame(nextLevel);
        }

        // Transition to Win screen
        Time.timeScale = 1f;
        SceneManager.LoadScene("WinScreen");
    }

    void PauseGame()
    {
        if (Time.timeScale == 1f)
        {
            Time.timeScale = 0f;
            Debug.Log("Game Paused - Press ESC to resume");
            // You could show a simple pause overlay here
        }
        else
        {
            Time.timeScale = 1f;
            Debug.Log("Game Resumed");
        }
    }
}
