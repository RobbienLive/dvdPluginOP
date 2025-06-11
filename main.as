//
// DVD Logo Plugin - Main Entry & UI
// ---------------------------------
// This file handles the plugin entry point, menu, settings UI, and rendering loop.
// All logic for DVD logo movement is in dvd_logic.as.
//
// Author: RobbienLive
//

UI::Texture@ dvdLogo;         // The DVD logo texture
bool disabled = false;        // If true, the logo is hidden/paused
float dvdSpeed = 5.0f;        // Logo movement speed

// Called once when the plugin loads
void Main() {
    @dvdLogo = UI::LoadTexture("img/dvd_logo.png");
}

// Renders the plugin menu entry
void RenderMenu() {
    // Show checkmark if enabled (not disabled)
    if (UI::MenuItem("DVD Logo", "", !disabled)) {
        disabled = !disabled;
        if (disabled) {
            UI::SetTooltip("Disabled");
            print("Disabled DVD Logo");
        } else {
            print("Enabled DVD Logo");
            UI::SetTooltip("Enabled");
        }
    }
}

// Renders the settings tab in the Openplanet UI
[SettingsTab name="DVD Logo"]
void RenderSettings() {
    // Slider to control logo speed
    float oldSpeed = dvdSpeed;
    dvdSpeed = UI::SliderFloat("Logo Speed", dvdSpeed, 1.0f, 30.0f);
    if (dvdSpeed != oldSpeed) {
        UpdateVelocity();
    }
    UI::Text("Current speed: " + Text::Format("%.1f", dvdSpeed));
}

// Called every frame to render the logo (if enabled)
void Render() {
    if (!disabled) {
        MoveDVDLogo(1920, 1080);
    }
}