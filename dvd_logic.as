//
// DVD Logo Plugin - Logic
// ----------------------
// Handles the movement, color cycling, and drawing of the DVD logo.
// Expects dvdLogo, dvdSpeed, and disabled to be defined in main.as.
//
// Author: RobbienLive
//

float imgX = 0, imgY = 0;           // Logo position
float velX = 5, velY = 5;           // Logo velocity
float imgWidth = 225, imgHeight = 128; // Logo size (adjust to your image)
int i = 0;                          // Color palette index

// 24-color palette for the logo edge bounces
const uint DVD_PALETTE_COUNT = 24;
uint[] dvdPalette = {
    0xFF0000AA, 0xFF4000AA, 0xFF8000AA, 0xFFBF00AA, 0xFFFF00AA, 0xBFFF00AA,
    0x80FF00AA, 0x40FF00AA, 0x00FF00AA, 0x00FF40AA, 0x00FF80AA, 0x00FFBFAA,
    0x00FFFFAA, 0x00BFFFAA, 0x0080FFAA, 0x0040FFAA, 0x0000FFAA, 0x4000FFAA,
    0x8000FFAA, 0xBF00FFAA, 0xFF00FFAA, 0xFF00BFAA, 0xFF0080AA, 0xFF0040AA
};
uint currentColor = dvdPalette[0];

/// Moves the DVD logo, bounces it off the screen edges, and cycles color.
/// Draws the logo at its current position.
/// @param screenW The width of the screen.
/// @param screenH The height of the screen.
void MoveDVDLogo(float screenW, float screenH) {
    imgX += velX;
    imgY += velY;

    bool bounced = false;

    // Bounce off left/right
    if (imgX <= 0 || imgX + imgWidth >= screenW) {
        velX = -velX;
        imgX = clamp(imgX, 0, screenW - imgWidth);
        bounced = true;
    }
    // Bounce off top/bottom
    if (imgY <= 0 || imgY + imgHeight >= screenH) {
        velY = -velY;
        imgY = clamp(imgY, 0, screenH - imgHeight);
        bounced = true;
    }

    // Cycle color on bounce
    if (bounced) {
        i += 1;
        i = i % DVD_PALETTE_COUNT;
        currentColor = dvdPalette[i];
    }

    // Draw the image at the new position using fixed dimensions
    if (dvdLogo !is null) {
        UI::DrawList@ dl = UI::GetBackgroundDrawList();
        dl.AddImage(dvdLogo, vec2(imgX, imgY), vec2(imgX + imgWidth, imgY + imgHeight), currentColor);
    }
}

/// Updates the velocity of the logo based on the current speed.
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

/// Clamps a value between minVal and maxVal.
float clamp(float val, float minVal, float maxVal) {
    if (val < minVal) return minVal;
    if (val > maxVal) return maxVal;
    return val;
}