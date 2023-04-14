//
//  BackgroundMusicManager.swift
//  mice_wedding
//
//  Created by Thanh Nguyen on 2023-04-13.
//

import AVFoundation

class BackgroundMusicManager {
    static let shared = BackgroundMusicManager()

    private var backgroundMusicPlayer: AVAudioPlayer?

    private init() {
        // Load and start playing the initial background music
        // SOUND CREDIT FROM UUBEAT: Teddy Bear Waltz - Kevin MacLeod
        // SOUND LINK: https://uppbeat.io/track/kevin-macleod/teddy-bear-waltz
        if let musicURL = Bundle.main.url(forResource: "N01_sound", withExtension: "mp3") {
            do {
                let musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer = musicPlayer
                musicPlayer.numberOfLoops = -1 // Play the music indefinitely
                musicPlayer.play()
            } catch {
                print("Error loading initial background music: \(error.localizedDescription)")
            }
        } else {
            print("Initial background music file not found.")
        }
    }

    func updateSound_Level01() {
        // Stop the current background music
        backgroundMusicPlayer?.stop()

        // Load and start playing the new background music
        // SOUND CREDIT FROM UPPBEAT: The Incident - Soundroll
        // LINK SOUND: https://uppbeat.io/track/soundroll/the-incident
        if let musicURL = Bundle.main.url(forResource: "N04_sound", withExtension: "mp3") {
            do {
                let musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer = musicPlayer
                musicPlayer.numberOfLoops = -1 // Play the music indefinitely
                musicPlayer.play()
            } catch {
                print("Error loading new background music: \(error.localizedDescription)")
            }
        } else {
            print("New background music file not found.")
        }
    }
    
    func updateSound_Level02() {
        // Stop the current background music
        backgroundMusicPlayer?.stop()

        // Load and start playing the new background music
        // SOUND CREDIT FROM UPPBEAT: No Time For Games - Soundroll
        // LINK SOUND: https://uppbeat.io/track/soundroll/no-time-for-games
        if let musicURL = Bundle.main.url(forResource: "N08_sound", withExtension: "mp3") {
            do {
                let musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer = musicPlayer
                musicPlayer.numberOfLoops = -1 // Play the music indefinitely
                musicPlayer.play()
            } catch {
                print("Error loading new background music: \(error.localizedDescription)")
            }
        } else {
            print("New background music file not found.")
        }
    }
    
    func updateSound_Win() {
        // Stop the current background music
        backgroundMusicPlayer?.stop()

        // Load and start playing the new background music
        // SOUND CREDIT FROM UPPBEAT: Tres French - Jonny Boyle
        // LINK SOUND: https://uppbeat.io/track/jonny-boyle/tres-french
        if let musicURL = Bundle.main.url(forResource: "N10_sound", withExtension: "mp3") {
            do {
                let musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer = musicPlayer
                musicPlayer.numberOfLoops = -1 // Play the music indefinitely
                musicPlayer.play()
            } catch {
                print("Error loading new background music: \(error.localizedDescription)")
            }
        } else {
            print("New background music file not found.")
        }
    }
}

