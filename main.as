UI::Texture@ dvdLogo;

// Variables for position, velocity, and image size
float imgX = 0, imgY = 0;
float velX = 5, velY = 5;
float imgWidth = 225, imgHeight = 128; // Set to your image's size
int i = 0;

const uint DVD_PALETTE_COUNT = 24;
uint[] dvdPalette = {
    0xFF0000CC, // red
    0xFF4000CC, // orange-red
    0xFF8000CC, // orange
    0xFFBF00CC, // amber
    0xFFFF00CC, // yellow
    0xBFFF00CC, // yellow-green
    0x80FF00CC, // lime-green
    0x40FF00CC, // spring green
    0x00FF00CC, // green
    0x00FF40CC, // turquoise-green
    0x00FF80CC, // aquamarine
    0x00FFBFCC, // cyan-green
    0x00FFFFCC, // cyan
    0x00BFFFCC, // deep sky blue
    0x0080FFCC, // dodger blue
    0x0040FFCC, // royal blue
    0x0000FFCC, // blue
    0x4000FFCC, // violet-blue
    0x8000FFCC, // blue-violet
    0xBF00FFCC, // violet
    0xFF00FFCC, // magenta
    0xFF00BFCC, // pink-magenta
    0xFF0080CC, // hot pink
    0xFF0040CC, // light red
};

uint currentColor = dvdPalette[0];

void Main() {
    @dvdLogo = UI::LoadTexture("dvd_logo.png");
}

void Render() {
    MoveDVDLogo(1920, 1080);
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
        print(i);
        i = i % 24; // Cycle through the palette
        currentColor = dvdPalette[i];
    }

    // Draw the image at the new position using fixed dimensions
    if (dvdLogo !is null) {
        UI::DrawList@ dl = UI::GetBackgroundDrawList();
        dl.AddImage(dvdLogo, vec2(imgX, imgY), vec2(imgWidth, imgHeight), currentColor);
    }
}

// Utility clamp function
float clamp(float val, float minVal, float maxVal) {
    if (val < minVal) return minVal;
    if (val > maxVal) return maxVal;
    return val;
}