"""Generate assets/lottie/kalori_wordmark.json: the KALORI wordmark animation.

Letters are stroked paths (no font needed). The O is a calorie ring whose green
arc fills; letters rise in with a stagger, a soft glow pulses, then everything
fades out so the 3.2 s animation loops cleanly.

Usage (from the repo root):
    python tool/lottie/make_wordmark.py assets/lottie/kalori_wordmark.json

Colors match KaloriColors (DESIGN.md §2); timing is in frames at 60 fps.
"""
import json
import sys

FPS = 60
OP = 192  # 3.2 s
W, H = 600, 300
INK = [13 / 255, 28 / 255, 47 / 255, 1]  # onSurface #0D1C2F
GREEN = [16 / 255, 185 / 255, 129 / 255, 1]  # successGreen #10B981
TRACK = [221 / 255, 233 / 255, 255 / 255, 1]  # surfaceContainerHigh #DDE9FF
GLOW = [111 / 255, 251 / 255, 190 / 255, 1]  # primaryFixed #6FFBBE
STROKE = 22
TOP, BOTTOM, MID = 100, 200, 150


def ease(dims, ox=0.33, oy=0.0, ix=0.2, iy=1.0):
    return {"o": {"x": [ox] * dims, "y": [oy] * dims}, "i": {"x": [ix] * dims, "y": [iy] * dims}}


def kf(t, s, dims=None, **e):
    d = {"t": t, "s": s if isinstance(s, list) else [s]}
    d.update(ease(dims or len(d["s"]), **e))
    return d


def static(v):
    return {"a": 0, "k": v}


def line_path(points, closed=False):
    n = len(points)
    return {
        "ty": "sh",
        "ks": static({"c": closed, "v": points, "i": [[0, 0]] * n, "o": [[0, 0]] * n}),
    }


def bezier_path(v, i, o, closed=False):
    return {"ty": "sh", "ks": static({"c": closed, "v": v, "i": i, "o": o})}


def stroke(color, width=STROKE):
    return {"ty": "st", "c": static(color), "o": static(100), "w": static(width), "lc": 2, "lj": 2, "ml": 4}


def fill(color, opacity=100):
    return {"ty": "fl", "c": static(color), "o": static(opacity), "r": 1}


def group(name, items):
    tr = {
        "ty": "tr",
        "p": static([0, 0]),
        "a": static([0, 0]),
        "s": static([100, 100]),
        "r": static(0),
        "o": static(100),
        "sk": static(0),
        "sa": static(0),
    }
    return {"ty": "gr", "nm": name, "it": items + [tr]}


def letter_layer(ind, name, cx, shapes, delay):
    """Shape layer that rises in (staggered by delay frames), holds, then fades out."""
    a = 14 + delay  # start
    b = a + 24  # overshoot peak
    c = b + 14  # settle
    out0, out1 = 166, 190
    return {
        "ddd": 0,
        "ind": ind,
        "ty": 4,
        "nm": name,
        "sr": 1,
        "ks": {
            "o": {"a": 1, "k": [kf(a, 0), kf(b, 100), kf(out0, 100), {"t": out1, "s": [0]}]},
            "r": static(0),
            "p": {
                "a": 1,
                "k": [
                    kf(a, [cx, MID + 34, 0]),
                    kf(b, [cx, MID - 6, 0]),
                    kf(c, [cx, MID, 0]),
                    kf(out0, [cx, MID, 0]),
                    {"t": out1, "s": [cx, MID - 12, 0]},
                ],
            },
            "a": static([cx, MID, 0]),
            "s": {
                "a": 1,
                "k": [kf(a, [85, 85, 100]), kf(b, [104, 104, 100]), {"t": c, "s": [100, 100, 100]}],
            },
        },
        "ao": 0,
        "shapes": shapes,
        "ip": 0,
        "op": OP,
        "st": 0,
        "bm": 0,
    }


def build():
    layers = []
    # Glyph boxes (x ranges), total width 454 centred in 600.
    k0, a0, l0, ocx, r0, ix = 73, 157, 245, 371, 445, 527

    k = group("K", [
        line_path([[k0, TOP], [k0, BOTTOM]]),
        line_path([[k0 + 58, TOP], [k0 + 4, 152]]),
        line_path([[k0 + 20, 138], [k0 + 60, BOTTOM]]),
        stroke(INK),
    ])
    a = group("A", [
        line_path([[a0, BOTTOM], [a0 + 32, TOP], [a0 + 64, BOTTOM]]),
        line_path([[a0 + 14, 166], [a0 + 50, 166]]),
        stroke(INK),
    ])
    l_ = group("L", [line_path([[l0, TOP], [l0, BOTTOM], [l0 + 52, BOTTOM]]), stroke(INK)])

    ring_r = 39
    o_track = group("O track", [
        {"ty": "el", "p": static([ocx, MID]), "s": static([ring_r * 2, ring_r * 2]), "d": 1},
        stroke(TRACK),
    ])
    o_fill = group("O fill", [
        {"ty": "el", "p": static([ocx, MID]), "s": static([ring_r * 2, ring_r * 2]), "d": 1},
        {
            "ty": "tm",
            "s": static(0),
            "e": {"a": 1, "k": [kf(66, 0, ox=0.45, ix=0.3), kf(124, 100), {"t": 190, "s": [100]}]},
            "o": static(0),
            "m": 1,
        },
        stroke(GREEN),
    ])
    # Start the arc at 12 o'clock.
    o_fill["it"][-1]["r"] = static(0)

    r = group("R", [
        line_path([[r0, BOTTOM], [r0, TOP]]),
        bezier_path(
            v=[[r0, TOP], [r0 + 33, TOP], [r0 + 33, 152], [r0, 152]],
            i=[[0, 0], [0, 0], [17, 0], [0, 0]],
            o=[[0, 0], [17, 0], [0, 0], [0, 0]],
        ),
        line_path([[r0 + 28, 152], [r0 + 58, BOTTOM]]),
        stroke(INK),
    ])
    i_ = group("I", [line_path([[ix, TOP], [ix, BOTTOM]]), stroke(GREEN)])

    glyphs = [
        ("K", (k0 + k0 + 60) / 2, [k]),
        ("A", a0 + 32, [a]),
        ("L", l0 + 26, [l_]),
        ("O", ocx, [o_fill, o_track]),  # first item draws on top
        ("R", r0 + 29, [r]),
        ("I", ix, [i_]),
    ]
    for n, (name, cx, shapes) in enumerate(glyphs):
        layers.append(letter_layer(n + 1, name, cx, shapes, delay=n * 5))

    # Soft glow behind the O: many faint stacked circles approximate a radial
    # gradient (blur effects are unreliable across Lottie players).
    glow_shapes = [
        group(f"glow {r_}", [
            {"ty": "el", "p": static([ocx, MID]), "s": static([r_ * 2, r_ * 2]), "d": 1},
            fill(GLOW, 7),
        ])
        for r_ in range(120, 40, -10)
    ]
    layers.append({
        "ddd": 0,
        "ind": len(layers) + 1,
        "ty": 4,
        "nm": "Glow",
        "sr": 1,
        "ks": {
            "o": {"a": 1, "k": [kf(100, 0), kf(136, 100), {"t": 190, "s": [0]}]},
            "r": static(0),
            "p": static([ocx, MID, 0]),
            "a": static([ocx, MID, 0]),
            "s": {"a": 1, "k": [kf(100, [70, 70, 100]), kf(136, [100, 100, 100]), {"t": 190, "s": [110, 110, 100]}]},
        },
        "ao": 0,
        "shapes": glow_shapes,
        "ip": 0,
        "op": OP,
        "st": 0,
        "bm": 0,
    })

    return {
        "v": "5.7.4",
        "fr": FPS,
        "ip": 0,
        "op": OP,
        "w": W,
        "h": H,
        "nm": "kalori_wordmark",
        "ddd": 0,
        "assets": [],
        "layers": layers,
        "markers": [],
    }


if __name__ == "__main__":
    out = sys.argv[1]
    with open(out, "w", encoding="utf-8") as f:
        json.dump(build(), f, separators=(",", ":"))
    print("wrote", out)
