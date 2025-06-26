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
float screenW = 1920.0f;
float screenH = 1080.0f;

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

[SettingsTab name="Screen Size"]
void RenderScreenSizeSettings() {

    UI::Text("Choose a preset for the screen size that matches your resolution.");

    string[] widthPresets = {"640", "1280", "1920", "2560", "3840"};
    string[] heightPresets = {"360", "720", "1080", "1440", "2160"};

    // Preset + custom optie
    string[] widthOptions = widthPresets;
    widthOptions.InsertLast("Custom");
    string[] heightOptions = heightPresets;
    heightOptions.InsertLast("Custom");

    // --- WIDTH ---
    int selectedW = widthOptions.Length - 1; // Default to "Custom"
    for (uint i = 0; i < widthPresets.Length; i++) {
        if (Math::Abs(screenW - Text::ParseInt(widthPresets[i])) < 1.0f) {
            selectedW = int(i);
            break;
        }
    }
    if (UI::BeginCombo("Screen Width Preset", widthOptions[selectedW])) {
        for (uint i = 0; i < widthOptions.Length; i++) {
            bool isSelected = selectedW == int(i);
            if (UI::Selectable(widthOptions[i], isSelected)) {
                if (i < widthPresets.Length) {
                    screenW = Text::ParseInt(widthPresets[i]);
                    screenH = Text::ParseInt(heightPresets[i]); // hoogte mee aanpassen!
                }
                selectedW = int(i);
            }
            if (isSelected) UI::SetItemDefaultFocus();
        }
        UI::EndCombo();
    }

    // --- HEIGHT ---
    int selectedH = heightOptions.Length - 1; // Default to "Custom"
    for (uint i = 0; i < heightPresets.Length; i++) {
        if (Math::Abs(screenH - Text::ParseInt(heightPresets[i])) < 1.0f) {
            selectedH = int(i);
            break;
        }
    }
    if (UI::BeginCombo("Screen Height Preset", heightOptions[selectedH])) {
        for (uint i = 0; i < heightOptions.Length; i++) {
            bool isSelected = selectedH == int(i);
            if (UI::Selectable(heightOptions[i], isSelected)) {
                if (i < heightPresets.Length) {
                    screenH = Text::ParseInt(heightPresets[i]);
                    screenW = Text::ParseInt(widthPresets[i]); // breedte mee aanpassen!
                }
                selectedH = int(i);
            }
            if (isSelected) UI::SetItemDefaultFocus();
        }
        UI::EndCombo();
    }

    // Custom input
    UI::Text("Enter a custom value for the screen size that matches your resolution.");
    int prevW = int(screenW), prevH = int(screenH);
    screenW = float(UI::InputInt("Screen Width", prevW));
    screenH = float(UI::InputInt("Screen Height", prevH));

    // Zet preset op "Custom" als handmatig aangepast
    bool matchedW = false, matchedH = false;
    for (uint i = 0; i < widthPresets.Length; i++) {
        if (Math::Abs(screenW - Text::ParseInt(widthPresets[i])) < 1.0f) matchedW = true;
        if (Math::Abs(screenH - Text::ParseInt(heightPresets[i])) < 1.0f) matchedH = true;
    }
    if (!matchedW) selectedW = widthOptions.Length - 1;
    if (!matchedH) selectedH = heightOptions.Length - 1;
}

[SettingsTab name="General"]
void RenderGeneralSettings() {
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
        MoveDVDLogoAll(screenW, screenH);
    }
}