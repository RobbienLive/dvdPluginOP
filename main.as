UI::Texture@ dvdLogo;

// Variables for position, velocity, and image size
float imgX = 0, imgY = 0;
float velX = 5, velY = 5;
float imgWidth = 225, imgHeight = 128; // Set to your image's size
int i = 0;
bool disabled = false;

float dvdSpeed = 5.0f; // Default speed

const uint DVD_PALETTE_COUNT = 24;
uint[] dvdPalette = {
    0xFF0000AA, // red
    0xFF4000AA, // orange-red
    0xFF8000AA, // orange
    0xFFBF00AA, // amber
    0xFFFF00AA, // yellow
    0xBFFF00AA, // yellow-green
    0x80FF00AA, // lime-green
    0x40FF00AA, // spring green
    0x00FF00AA, // green
    0x00FF40AA, // turquoise-green
    0x00FF80AA, // aquamarine
    0x00FFBFAA, // cyan-green
    0x00FFFFAA, // cyan
    0x00BFFFAA, // deep sky blue
    0x0080FFAA, // dodger blue
    0x0040FFAA, // royal blue
    0x0000FFAA, // blue
    0x4000FFAA, // violet-blue
    0x8000FFAA, // blue-violet
    0xBF00FFAA, // violet
    0xFF00FFAA, // magenta
    0xFF00BFAA, // pink-magenta
    0xFF0080AA, // hot pink
    0xFF0040AA, // light red
};

uint currentColor = dvdPalette[0];

void Main() {
    @dvdLogo = UI::LoadTexture("dvd_logo.png");
}

void RenderMenu()
{
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

[SettingsTab name="DVD Logo"]
void RenderSettings() {
    float oldSpeed = dvdSpeed;
    dvdSpeed = UI::SliderFloat("Logo Speed", dvdSpeed, 1.0f, 30.0f);
    if (dvdSpeed != oldSpeed) {
        UpdateVelocity();
    }
    UI::Text("Current speed: " + Text::Format("%.1f", dvdSpeed));
}

void Render() {
    if (!disabled) {
        MoveDVDLogo(1920, 1080);
    }
}

void MoveDVDLogo(float screenW, float screenH) {
    // Move the image
    imgX += velX;
    imgY += velY;


    bool bounced = false;

    // Bounce off left/right (ensure the image stays fully visible)
    if (imgX <= 0 || imgX + imgWidth >= screenW) {
        velX = -velX;
        imgX = clamp(imgX, 0, screenW - imgWidth);
        bounced = true;
    }
    // Bounce off top/bottom (ensure the image stays fully visible)
    if (imgY <= 0 || imgY + imgHeight >= screenH) {
        velY = -velY;
        imgY = clamp(imgY, 0, screenH - imgHeight);
        bounced = true;
    }

    if (bounced) {
        i += 1;
        i = i % 24; // Cycle through the palette
        currentColor = dvdPalette[i];
    }

    // Draw the image at the new position using fixed dimensions
    if (dvdLogo !is null) {
        UI::DrawList@ dl = UI::GetBackgroundDrawList();
        dl.AddImage(dvdLogo, vec2(imgX, imgY), vec2(imgWidth, imgHeight), currentColor);
    }
}

// Update velocity when speed changes
void UpdateVelocity() {
    float norm = Math::Sqrt(velX * velX + velY * velY);
    if (norm > 0.0f) {
        velX = (velX / norm) * dvdSpeed;
        velY = (velY / norm) * dvdSpeed;
    } else {
        velX = dvdSpeed;
        velY = dvdSpeed;
    }
}

// Utility clamp function
float clamp(float val, float minVal, float maxVal) {
    if (val < minVal) return minVal;
    if (val > maxVal) return maxVal;
    return val;
}