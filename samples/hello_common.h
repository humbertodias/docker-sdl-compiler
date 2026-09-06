#pragma once

#include <string.h>
#include <stdio.h>

#define HELLO_SCREEN_W 640
#define HELLO_SCREEN_H 480
#define HELLO_CARD_W 360
#define HELLO_SCALE 3
#define HELLO_VER_SCALE 2

typedef struct HelloLibVersion {
    const char* name;
    int major;
    int minor;
    int patch;
} HelloLibVersion;

typedef void (*HelloFillFn)(void* ctx, int x, int y, int w, int h, unsigned color);

/* 5x7 glyphs: A-Z then 0-9 */
static const unsigned char HELLO_FONT_5X7[][7] = {
    /* A-Z */
    {0x0E, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11},
    {0x1E, 0x11, 0x11, 0x1E, 0x11, 0x11, 0x1E},
    {0x0E, 0x11, 0x10, 0x10, 0x10, 0x11, 0x0E},
    {0x1E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x1E},
    {0x1F, 0x10, 0x10, 0x1E, 0x10, 0x10, 0x1F},
    {0x1F, 0x10, 0x10, 0x1E, 0x10, 0x10, 0x10},
    {0x0E, 0x11, 0x10, 0x17, 0x11, 0x11, 0x0E},
    {0x11, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11},
    {0x0E, 0x04, 0x04, 0x04, 0x04, 0x04, 0x0E},
    {0x01, 0x01, 0x01, 0x01, 0x11, 0x11, 0x0E},
    {0x11, 0x12, 0x14, 0x18, 0x14, 0x12, 0x11},
    {0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x1F},
    {0x11, 0x1B, 0x15, 0x15, 0x11, 0x11, 0x11},
    {0x11, 0x19, 0x15, 0x13, 0x11, 0x11, 0x11},
    {0x0E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E},
    {0x1E, 0x11, 0x11, 0x1E, 0x10, 0x10, 0x10},
    {0x0E, 0x11, 0x11, 0x11, 0x15, 0x12, 0x0D},
    {0x1E, 0x11, 0x11, 0x1E, 0x14, 0x12, 0x11},
    {0x0E, 0x11, 0x10, 0x0E, 0x01, 0x11, 0x0E},
    {0x1F, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04},
    {0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E},
    {0x11, 0x11, 0x11, 0x11, 0x11, 0x0A, 0x04},
    {0x11, 0x11, 0x11, 0x15, 0x15, 0x1B, 0x11},
    {0x11, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x11},
    {0x11, 0x11, 0x0A, 0x04, 0x04, 0x04, 0x04},
    {0x1F, 0x01, 0x02, 0x04, 0x08, 0x10, 0x1F},
    /* 0-9 */
    {0x0E, 0x11, 0x13, 0x15, 0x19, 0x11, 0x0E}, /* 0 */
    {0x04, 0x0C, 0x04, 0x04, 0x04, 0x04, 0x0E}, /* 1 */
    {0x0E, 0x11, 0x01, 0x02, 0x04, 0x08, 0x1F}, /* 2 */
    {0x1F, 0x02, 0x04, 0x02, 0x01, 0x11, 0x0E}, /* 3 */
    {0x02, 0x06, 0x0A, 0x12, 0x1F, 0x02, 0x02}, /* 4 */
    {0x1F, 0x10, 0x1E, 0x01, 0x01, 0x11, 0x0E}, /* 5 */
    {0x06, 0x08, 0x10, 0x1E, 0x11, 0x11, 0x0E}, /* 6 */
    {0x1F, 0x01, 0x02, 0x04, 0x08, 0x08, 0x08}, /* 7 */
    {0x0E, 0x11, 0x11, 0x0E, 0x11, 0x11, 0x0E}, /* 8 */
    {0x0E, 0x11, 0x11, 0x0F, 0x01, 0x02, 0x0C}, /* 9 */
};

static const unsigned char* hello_glyph(char c) {
    if (c >= 'A' && c <= 'Z') {
        return HELLO_FONT_5X7[c - 'A'];
    }
    if (c >= 'a' && c <= 'z') {
        return HELLO_FONT_5X7[c - 'a'];
    }
    if (c >= '0' && c <= '9') {
        return HELLO_FONT_5X7[26 + (c - '0')];
    }
    return NULL;
}

static const unsigned char HELLO_FONT_DOT[7] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x0C};

static void hello_draw_char(HelloFillFn fill, void* ctx, char c, int x, int y, int scale, unsigned color) {
    const unsigned char* glyph = (c == '.') ? HELLO_FONT_DOT : hello_glyph(c);
    if (!glyph) {
        return;
    }
    for (int row = 0; row < 7; ++row) {
        for (int col = 0; col < 5; ++col) {
            if (glyph[row] & (1 << (4 - col))) {
                fill(ctx, x + col * scale, y + row * scale, scale, scale, color);
            }
        }
    }
}

static void hello_draw_text(HelloFillFn fill, void* ctx, const char* text, int x, int y, int scale, unsigned color) {
    int cursor = x;
    for (const char* p = text; *p; ++p) {
        if (*p == ' ') {
            cursor += 4 * scale;
            continue;
        }
        hello_draw_char(fill, ctx, *p, cursor, y, scale, color);
        cursor += 6 * scale;
    }
}

static int hello_text_width(const char* text, int scale) {
    return (int)strlen(text) * 6 * scale - scale;
}

static int hello_text_height(int scale) {
    return 7 * scale;
}

static int hello_card_height(int nlibs) {
    const int pad = 14;
    const int title_h = hello_text_height(HELLO_SCALE);
    const int ver_h = hello_text_height(HELLO_VER_SCALE);
    const int title_gap = 8;
    const int ver_gap = 3;
    int h = pad * 2 + title_h + title_gap;
    if (nlibs > 0) {
        h += nlibs * ver_h + (nlibs - 1) * ver_gap;
    }
    return h;
}

/* Draws white card with "HELLO WORLD" and one "NAME x.y.z" line per library. */
static void hello_paint_card(HelloFillFn fill, void* ctx, unsigned bg, unsigned border, unsigned text,
                             const HelloLibVersion* libs, int nlibs) {
    const int card_h = hello_card_height(nlibs);
    const int pad = 14;
    const int title_h = hello_text_height(HELLO_SCALE);
    const int ver_h = hello_text_height(HELLO_VER_SCALE);
    const int title_gap = 8;
    const int ver_gap = 3;

    fill(ctx, 0, 0, HELLO_CARD_W, card_h, border);
    fill(ctx, 4, 4, HELLO_CARD_W - 8, card_h - 8, bg);

    const char* line1 = "HELLO WORLD";
    int y = pad;
    hello_draw_text(
        fill, ctx, line1,
        (HELLO_CARD_W - hello_text_width(line1, HELLO_SCALE)) / 2,
        y, HELLO_SCALE, text
    );
    y += title_h + title_gap;

    for (int i = 0; i < nlibs; ++i) {
        char line[40];
        snprintf(line, sizeof(line), "%s %d.%d.%d", libs[i].name, libs[i].major, libs[i].minor, libs[i].patch);
        hello_draw_text(
            fill, ctx, line,
            (HELLO_CARD_W - hello_text_width(line, HELLO_VER_SCALE)) / 2,
            y, HELLO_VER_SCALE, text
        );
        y += ver_h + ver_gap;
    }
}
