using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// Manages background music and sound effects.
/// Singleton pattern - persists across scenes.
/// </summary>
public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance { get; private set; }

    [Header("Music")]
    public AudioClip menuMusic;
    public AudioClip gameMusic;

    [Header("Sound Effects")]
    public AudioClip jumpSfx;
    public AudioClip landSfx;
    public AudioClip winSfx;
    public AudioClip loseSfx;
    public AudioClip pushSfx;
    public AudioClip changeColorSfx;

    private AudioSource musicPlayer;
    private Dictionary<string, AudioClip> sfxClips;

    void Awake()
    {
        // Singleton pattern
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
            InitializeAudio();
        }
        else
        {
            Destroy(gameObject);
        }
    }

    void InitializeAudio()
    {
        // Create music player
        musicPlayer = gameObject.AddComponent<AudioSource>();
        musicPlayer.loop = true;
        musicPlayer.playOnAwake = false;

        // Cache sound effects
        sfxClips = new Dictionary<string, AudioClip>
        {
            { "jump", jumpSfx },
            { "land", landSfx },
            { "win", winSfx },
            { "lose", loseSfx },
            { "push", pushSfx },
            { "change_color", changeColorSfx }
        };

        Debug.Log("[AudioManager] Initialized");
    }

    public void PlayMenuMusic()
    {
        if (menuMusic != null && musicPlayer.clip != menuMusic)
        {
            musicPlayer.clip = menuMusic;
            musicPlayer.volume = 1f;
            if (!musicPlayer.isPlaying)
            {
                musicPlayer.Play();
            }
        }
    }

    public void PlayGameMusic()
    {
        if (gameMusic != null && musicPlayer.clip != gameMusic)
        {
            musicPlayer.clip = gameMusic;
            musicPlayer.volume = 1f;
            if (!musicPlayer.isPlaying)
            {
                musicPlayer.Play();
            }
        }
    }

    public void StopMusic()
    {
        if (musicPlayer.isPlaying)
        {
            musicPlayer.Stop();
        }
    }

    public void PauseMusic()
    {
        if (musicPlayer.isPlaying)
        {
            musicPlayer.Pause();
        }
    }

    public void ResumeMusic()
    {
        if (!musicPlayer.isPlaying)
        {
            musicPlayer.UnPause();
        }
    }

    public void PlaySfx(string sfxName)
    {
        if (sfxClips.ContainsKey(sfxName) && sfxClips[sfxName] != null)
        {
            // Create temporary audio source for overlapping sounds
            GameObject tempObj = new GameObject("TempSFX_" + sfxName);
            AudioSource tempSource = tempObj.AddComponent<AudioSource>();
            tempSource.clip = sfxClips[sfxName];
            tempSource.playOnAwake = false;
            tempSource.Play();

            // Destroy after playing
            Destroy(tempObj, sfxClips[sfxName].length);
        }
        else
        {
            Debug.LogWarning("[AudioManager] SFX not found: " + sfxName);
        }
    }
}
