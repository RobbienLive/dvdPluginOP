//
// DVD Logo Plugin - Main Entry & UI
// ---------------------------------
// Handles the plugin entry point, menu, settings UI, and rendering loop.
// All logic for DVD logo movement is in dvd_logic.as.
//
// Author: RobbienLive
//

UI::Texture@ dvdLogo;         // The DVD logo texture
bool disabled = false;        // If true, the logo is hidden/paused
float dvdSpeed = 5.7f;        // Logo movement speed
int logoCount = 1;            // Number of logos to show

void Main() {
    @dvdLogo = UI::LoadTexture("img/dvd_logo.png");
    SetLogoCount(logoCount);
}

void RenderMenu() {
    // Use the VideoCamera icon in orange color in the menu
    if (UI::MenuItem("\\$fa0" + Icons::VideoCamera + "\\$z DVD Logo", "", !disabled)) {
        disabled = !disabled;
    }
}

// Renders the settings tab in the Openplanet UI
[SettingsTab name="DVD Overlay"]
void RenderSettings() {
    // Slider to control number of logos
    int oldLogoCount = logoCount;
    logoCount = int(UI::SliderInt("Number of Logos", logoCount, 1, 20));
    if (logoCount != oldLogoCount) {
        SetLogoCount(logoCount);
    }

    // Slider to control logo speed
    float oldSpeed = dvdSpeed;
    dvdSpeed = UI::SliderFloat("Logo Speed", dvdSpeed, 1.0f, 30.0f);
    if (dvdSpeed != oldSpeed) {
        UpdateVelocity();
    }
}

// Called every frame to render the logos (if enabled)
void Render() {
    if (!disabled) {
        MoveDVDLogoAll(1920, 1080);
    }
}