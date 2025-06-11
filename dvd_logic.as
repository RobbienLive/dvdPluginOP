//
// DVD Logo Plugin - Logic
// ----------------------
// Handles the movement, color cycling, and drawing of multiple DVD logos.
// Expects dvdLogo, dvdSpeed, and logoCount to be defined in main.as.
//
// Author: RobbienLive
//

// --- Struct for a single logo instance ---
class DVDLogo {
    float x, y;
    float vx, vy;
    uint color;
    int paletteIdx;

    DVDLogo(float startX, float startY, float startVX, float startVY, int paletteIdx = 0) {
        x = startX;
        y = startY;
        vx = startVX;
        vy = startVY;
        this.paletteIdx = paletteIdx;
        color = dvdPalette[paletteIdx % DVD_PALETTE_COUNT];
    }
}

float imgWidth = 225, imgHeight = 128; // Logo size (adjust to your image)

// 24-color palette for the logo edge bounces
const uint DVD_PALETTE_COUNT = 24;
uint[] dvdPalette = {
    0xFF0000AA, 0xFF4000AA, 0xFF8000AA, 0xFFBF00AA, 0xFFFF00AA, 0xBFFF00AA,
    0x80FF00AA, 0x40FF00AA, 0x00FF00AA, 0x00FF40AA, 0x00FF80AA, 0x00FFBFAA,
    0x00FFFFAA, 0x00BFFFAA, 0x0080FFAA, 0x0040FFAA, 0x0000FFAA, 0x4000FFAA,
    0x8000FFAA, 0xBF00FFAA, 0xFF00FFAA, 0xFF00BFAA, 0xFF0080AA, 0xFF0040AA
};

array<DVDLogo@> dvdLogos;

/// Sets the number of logos on screen, adding/removing as needed.
void SetLogoCount(int count) {
    // Remove extra logos
    while (dvdLogos.Length > count) {
        dvdLogos.RemoveLast();
    }
    // Add new logos
    while (dvdLogos.Length < count) {
        float x = Math::Rand(0, 1600);
        float y = Math::Rand(0, 800);
        float angle = Math::Rand(0.0f, 2 * Math::PI);
        float speed = dvdSpeed;
        float vx = Math::Cos(angle) * speed;
        float vy = Math::Sin(angle) * speed;
        int paletteIdx = int(Math::Rand(0, DVD_PALETTE_COUNT));
        dvdLogos.InsertLast(DVDLogo(x, y, vx, vy, paletteIdx));
    }
}

/// Moves and draws all DVD logos, bouncing and cycling color as needed.
void MoveDVDLogoAll(float screenW, float screenH) {
    for (uint idx = 0; idx < dvdLogos.Length; ++idx) {
        DVDLogo@ logo = dvdLogos[idx];
        logo.x += logo.vx;
        logo.y += logo.vy;

        bool bounced = false;

        // Bounce off left/right
        if (logo.x <= 0 || logo.x + imgWidth >= screenW) {
            logo.vx = -logo.vx;
            logo.x = clamp(logo.x, 0, screenW - imgWidth);
            bounced = true;
        }
        // Bounce off top/bottom
        if (logo.y <= 0 || logo.y + imgHeight >= screenH) {
            logo.vy = -logo.vy;
            logo.y = clamp(logo.y, 0, screenH - imgHeight);
            bounced = true;
        }

        // Cycle color on bounce
        if (bounced) {
            logo.paletteIdx = (logo.paletteIdx + 1) % DVD_PALETTE_COUNT;
            logo.color = dvdPalette[logo.paletteIdx];
        }

        // Draw the image at the new position using fixed dimensions
        if (dvdLogo !is null) {
            UI::DrawList@ dl = UI::GetBackgroundDrawList();
            dl.AddImage(dvdLogo, vec2(logo.x, logo.y), vec2(imgWidth, imgHeight), logo.color);
        }
    }
}

/// Updates the velocity of all logos based on the current speed.
void UpdateVelocity() {
    for (uint idx = 0; idx < dvdLogos.Length; ++idx) {
        DVDLogo@ logo = dvdLogos[idx];
        float norm = Math::Sqrt(logo.vx * logo.vx + logo.vy * logo.vy);
        if (norm > 0.0f) {
            logo.vx = (logo.vx / norm) * dvdSpeed;
            logo.vy = (logo.vy / norm) * dvdSpeed;
        } else {
            logo.vx = dvdSpeed;
            logo.vy = dvdSpeed;
        }
    }
}

/// Clamps a value between minVal and maxVal.
float clamp(float val, float minVal, float maxVal) {
    if (val < minVal) return minVal;
    if (val > maxVal) return maxVal;
    return val;
}