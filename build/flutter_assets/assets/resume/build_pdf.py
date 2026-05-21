"""Generates resume.pdf using fpdf2 (pure Python, no system deps)."""

import os
from fpdf import FPDF, XPos, YPos

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                   "resume.pdf")

# ── Palette ──────────────────────────────────────────────────────────────────
ACCENT   = (13,  148, 136)   # #0D9488 teal
ACCENT_L = (204, 251, 241)   # #CCFBF1 light teal
DARK     = (15,  23,  42)    # #0F172A
BODY     = (51,  65,  85)    # #334155
MUTED    = (100, 116, 139)   # #64748B
SIDEBAR  = (248, 250, 252)   # #F8FAFC
BORDER   = (226, 232, 240)   # #E2E8F0
TAG_BG   = (241, 245, 249)   # #F1F5F9
WHITE    = (255, 255, 255)
BLACK    = (0,   0,   0)

# ── Geometry (mm) ────────────────────────────────────────────────────────────
PW, PH      = 210, 297         # A4
ML, MR      = 0, 0             # page margins (we handle manually)
SIDEBAR_W   = 68
MAIN_X      = SIDEBAR_W
MAIN_W      = PW - SIDEBAR_W
PAD         = 5.5              # inner horizontal padding
TOP         = 38               # y after header

# ── Data ─────────────────────────────────────────────────────────────────────
SKILLS = [
    ("Flutter",             95),
    ("Dart",                90),
    ("REST APIs",           90),
    ("Provider / Riverpod", 88),
    ("Firebase",            85),
    ("Git",                 85),
    ("UI / UX Design",      80),
    ("CI / CD",             75),
]

TOOLS_PRIMARY   = ["Flutter","Dart","Firebase","Riverpod","Provider"]
TOOLS_SECONDARY = ["React","Next.js","Node.js","Express","MongoDB",
                   "MySQL","TypeScript","SQLite","REST APIs","GraphQL","Git"]

PRACTICES = [
    "Clean Architecture", "SOLID Principles",
    "TDD", "Agile / Scrum",
    "State Management", "Performance Optimisation",
    "App Store Deployment", "Push Notifications",
]

LANGUAGES = [("English","Professional"), ("Hindi","Native")]

SUMMARY = (
    "Passionate and results-driven Software Engineer with 3+ years of "
    "experience in mobile app development, specialising in Flutter. "
    "Skilled in building high-performance, scalable, and user-friendly "
    "cross-platform apps for Android and iOS using Clean Architecture "
    "and modern UI/UX principles. Delivered 4 production apps live on "
    "Google Play and the Apple App Store. Open to full-time or "
    "freelance opportunities worldwide."
)

EXPERIENCE = [
    {
        "role":    "Software Developer",
        "company": "Live Informatics Deftsoft PVT LTD  ·  Mohali, India",
        "period":  "July 2023 - Present",
        "bullets": [
            "Develop cross-platform Flutter apps for Android & iOS, owning the full release cycle through both stores.",
            "Architect scalable solutions with Clean Architecture, SOLID principles, and TDD.",
            "Integrate Firebase, REST APIs, TT Lock SDK, Google Maps, and payment gateways.",
            "Implement real-time chat, push notifications, match algorithms, and booking flows.",
            "Deliver pixel-perfect UI from Figma designs; optimise performance and reduce build size.",
            "Collaborate via Agile; manage App Store and Play Store submissions end-to-end.",
        ],
    },
    {
        "role":    "Customer Service Associate",
        "company": "iEnergizer (Pine Labs)  ·  Noida, India",
        "period":  "June 2022 - Dec 2022",
        "bullets": [
            "Provided technical & account support for Pine Labs POS across merchant base in India.",
            "Resolved escalated issues efficiently, maintaining high customer-satisfaction scores.",
        ],
    },
]

PROJECTS = [
    {
        "title": "Dealsquawk",
        "store": "Apple App Store",
        "desc":  "Social community app — nests, posts, real-time chat & communities.",
        "stack": "Flutter · Firebase Auth · Firestore · Real-time Chat · REST APIs",
    },
    {
        "title": "YezidiLink",
        "store": "Google Play",
        "desc":  "Dating app — swipe matching, profile discovery, real-time chat.",
        "stack": "Flutter · Firebase · Real-time DB · Match Algorithm · Push Notifs",
    },
    {
        "title": "Modyaf",
        "store": "Google Play",
        "desc":  "Airbnb-style rental platform — smart room access, booking management.",
        "stack": "Flutter · Firebase · Google Maps · TT Lock SDK · Payment Gateway",
    },
    {
        "title": "SuperNotes AI",
        "store": "Google Play",
        "desc":  "AI note-taking app — audio-to-text, offline storage, drag & drop.",
        "stack": "Flutter · SQLite · Speech-to-Text · AI Processing · Provider",
    },
]


# ── PDF class ─────────────────────────────────────────────────────────────────

class Resume(FPDF):

    def __init__(self):
        super().__init__("P", "mm", "A4")
        self.set_auto_page_break(False)
        self.set_margins(0, 0, 0)
        self.add_page()
        self._sidebar_y = TOP   # current y pointer for sidebar
        self._main_y    = TOP   # current y pointer for main column

    # ── Helpers ──────────────────────────────────────────────────────────────

    def rgb(self, triplet):
        return triplet  # just a tuple alias for readability

    def set_col(self, r, g, b, which="fill"):
        if which == "fill":
            self.set_fill_color(r, g, b)
        elif which == "draw":
            self.set_draw_color(r, g, b)
        else:
            self.set_text_color(r, g, b)

    def section_rule(self, x, w, y):
        self.set_draw_color(*BORDER)
        self.set_line_width(0.2)
        self.line(x, y, x + w, y)

    def _safe(self, text):
        """Replace characters outside latin-1 with safe ASCII equivalents."""
        return (text
                .replace("–", "-").replace("—", "--")
                .replace("‘", "'").replace("’", "'")
                .replace("“", '"').replace("”", '"')
                .replace("·", "·")
                .encode("latin-1", errors="replace").decode("latin-1"))

    def _wrap_text(self, text, w, fs):
        """Return list of lines that fit in width w at font size fs."""
        text = self._safe(text)
        self.set_font("Helvetica", size=fs)
        words = text.split()
        lines, cur = [], ""
        for word in words:
            test = (cur + " " + word).strip()
            if self.get_string_width(test) <= w:
                cur = test
            else:
                if cur:
                    lines.append(cur)
                cur = word
        if cur:
            lines.append(cur)
        return lines

    # ── Header ───────────────────────────────────────────────────────────────

    def build_header(self):
        # background
        self.set_fill_color(*WHITE)
        self.rect(0, 0, PW, 36, "F")

        # Name
        self.set_xy(5, 7)
        self.set_font("Helvetica", "B", 22)
        self.set_text_color(*DARK)
        self.cell(self.get_string_width("Mohit "), 9, "Mohit ", new_x=XPos.RIGHT, new_y=YPos.TOP)
        self.set_text_color(*ACCENT)
        self.cell(40, 9, "Kapruwan", new_x=XPos.RIGHT, new_y=YPos.TOP)

        # Subtitle
        self.set_xy(5, 18)
        self.set_font("Helvetica", "", 8)
        self.set_text_color(*MUTED)
        self.cell(100, 5, "FLUTTER DEVELOPER  ·  MOBILE & CROSS-PLATFORM")

        # Contact block (right side)
        contacts = [
            "mohitkapruwan4@gmail.com   ·   +91 97199 72748",
            "Mohali, India",
            "linkedin.com/in/mohit-kapruwan-96b62b22b",
            "github.com/Mohit-Kapruwan-MK",
        ]
        cy = 7
        for line in contacts:
            self.set_font("Helvetica", "", 7.5)
            w = self.get_string_width(line)
            self.set_xy(PW - w - 5, cy)
            self.set_text_color(*MUTED)
            self.cell(w, 4.5, line)
            cy += 5

        # Accent rule
        self.set_draw_color(*ACCENT)
        self.set_line_width(0.8)
        self.line(0, 35.5, PW, 35.5)

    # ── Sidebar background ────────────────────────────────────────────────────

    def build_sidebar_bg(self):
        self.set_fill_color(*SIDEBAR)
        self.rect(0, TOP - 2, SIDEBAR_W, PH - TOP + 2, "F")
        self.set_draw_color(*BORDER)
        self.set_line_width(0.2)
        self.line(SIDEBAR_W, TOP - 2, SIDEBAR_W, PH)

    # ── Sidebar writing ───────────────────────────────────────────────────────

    def s_section_title(self, title):
        y = self._sidebar_y
        self.set_xy(PAD, y)
        self.set_font("Helvetica", "B", 7)
        self.set_text_color(*ACCENT)
        self.cell(SIDEBAR_W - PAD * 2, 4.5, title.upper())
        self.section_rule(PAD, SIDEBAR_W - PAD * 2, y + 5)
        self._sidebar_y = y + 7.5

    def s_skill_bar(self, name, pct):
        y = self._sidebar_y
        bar_w = SIDEBAR_W - PAD * 2

        # Label
        self.set_xy(PAD, y)
        self.set_font("Helvetica", "B", 8)
        self.set_text_color(*DARK)
        self.cell(bar_w - 8, 4, name)

        self.set_font("Helvetica", "", 7.5)
        self.set_text_color(*MUTED)
        self.set_xy(SIDEBAR_W - PAD - 8, y)
        self.cell(8, 4, f"{pct}%", align="R")

        # Track
        ty = y + 4.5
        self.set_fill_color(*BORDER)
        self.rect(PAD, ty, bar_w, 2.2, "F")

        # Fill
        filled_w = bar_w * pct / 100
        self.set_fill_color(*ACCENT)
        self.rect(PAD, ty, filled_w, 2.2, "F")

        self._sidebar_y = ty + 4.5

    def s_text(self, text, fs=8.5, bold=False, color=None):
        if color is None:
            color = BODY
        self.set_font("Helvetica", "B" if bold else "", fs)
        self.set_text_color(*color)
        lines = self._wrap_text(text, SIDEBAR_W - PAD * 2, fs)
        for line in lines:
            self.set_xy(PAD, self._sidebar_y)
            self.cell(SIDEBAR_W - PAD * 2, 4, line)
            self._sidebar_y += 4

    def s_tag_cloud(self, items, primary_items=None):
        x = PAD
        y = self._sidebar_y
        available_w = SIDEBAR_W - PAD * 2
        self.set_font("Helvetica", "", 7.5)

        for item in items:
            is_primary = primary_items and item in primary_items
            label = item
            tw = self.get_string_width(label) + 5

            if x + tw > SIDEBAR_W - PAD:
                x = PAD
                y += 5.5

            if is_primary:
                self.set_fill_color(*ACCENT_L)
                self.set_text_color(*ACCENT)
            else:
                self.set_fill_color(*TAG_BG)
                self.set_text_color(*MUTED)

            self.set_draw_color(*BORDER)
            self.set_line_width(0.1)
            self.rect(x, y, tw, 4.5, "FD")
            self.set_font("Helvetica", "B" if is_primary else "", 7)
            self.set_xy(x + 1, y + 0.5)
            self.cell(tw - 2, 3.5, label, align="C")
            x += tw + 2.5

        self._sidebar_y = y + 7

    def s_lang(self, name, level):
        y = self._sidebar_y
        self.set_font("Helvetica", "B", 8.5)
        self.set_text_color(*DARK)
        self.set_xy(PAD, y)
        self.cell(SIDEBAR_W - PAD * 2 - 20, 4.5, name)

        self.set_font("Helvetica", "", 7.5)
        self.set_text_color(*MUTED)
        self.set_xy(PAD, y)
        self.cell(SIDEBAR_W - PAD * 2, 4.5, level, align="R")
        self._sidebar_y = y + 5.5

    # ── Main column writing ───────────────────────────────────────────────────

    def m_section_title(self, title):
        y = self._main_y
        self.set_xy(MAIN_X + PAD, y)
        self.set_font("Helvetica", "B", 7)
        self.set_text_color(*ACCENT)
        self.cell(MAIN_W - PAD * 2, 4.5, title.upper())
        self.section_rule(MAIN_X + PAD, MAIN_W - PAD * 2, y + 5)
        self._main_y = y + 7.5

    def m_text(self, text, fs=9, bold=False, color=None, indent=0, line_h=4.2):
        if color is None:
            color = BODY
        self.set_font("Helvetica", "B" if bold else "", fs)
        self.set_text_color(*color)
        lines = self._wrap_text(text, MAIN_W - PAD * 2 - indent, fs)
        for line in lines:
            self.set_xy(MAIN_X + PAD + indent, self._main_y)
            self.cell(MAIN_W - PAD * 2 - indent, line_h, line)
            self._main_y += line_h

    def m_exp_header(self, role, period):
        y = self._main_y
        role, period = self._safe(role), self._safe(period)
        # Role
        self.set_font("Helvetica", "B", 11)
        self.set_text_color(*DARK)
        self.set_xy(MAIN_X + PAD, y)
        self.cell(MAIN_W - PAD * 2 - 38, 5.5, role)

        # Period pill (teal bg)
        pw = self.get_string_width(period) + 6
        px = MAIN_X + MAIN_W - PAD - pw
        self.set_fill_color(*ACCENT_L)
        self.set_draw_color(*ACCENT_L)
        self.set_line_width(0.1)
        self.rect(px, y + 0.5, pw, 4.5, "FD")
        self.set_font("Helvetica", "B", 7.5)
        self.set_text_color(*ACCENT)
        self.set_xy(px, y + 0.5)
        self.cell(pw, 4.5, period, align="C")

        self._main_y = y + 6.5

    def m_bullet(self, text, fs=8.5):
        y = self._main_y
        # Dot
        self.set_fill_color(*ACCENT)
        self.circle(MAIN_X + PAD + 1.2, y + 2, 1, "F")
        # Text
        self.set_font("Helvetica", "", fs)
        self.set_text_color(*BODY)
        lines = self._wrap_text(text, MAIN_W - PAD * 2 - 5, fs)
        for i, line in enumerate(lines):
            self.set_xy(MAIN_X + PAD + 4, y)
            self.cell(MAIN_W - PAD * 2 - 5, 4, line)
            y += 4
        self._main_y = y + 0.5

    def m_project(self, title, store, desc, stack):
        title, store, desc, stack = (self._safe(s) for s in (title, store, desc, stack))
        y = self._main_y
        box_h = 4.5 + 3.5 * len(self._wrap_text(desc, MAIN_W - PAD * 2 - 8, 8.5)) + \
                4 * len(self._wrap_text(f"Stack: {stack}", MAIN_W - PAD * 2 - 8, 7.5)) + 5

        # Box
        self.set_fill_color(*WHITE)
        self.set_draw_color(*BORDER)
        self.set_line_width(0.2)
        self.rect(MAIN_X + PAD, y, MAIN_W - PAD * 2, box_h, "FD")

        # Left accent bar
        self.set_fill_color(*ACCENT)
        self.rect(MAIN_X + PAD, y, 2.5, box_h, "F")

        # Title
        self.set_font("Helvetica", "B", 10)
        self.set_text_color(*DARK)
        self.set_xy(MAIN_X + PAD + 5, y + 1.5)
        self.cell(70, 4.5, title)

        # Store badge
        self.set_font("Helvetica", "B", 7.5)
        self.set_text_color(*ACCENT)
        sw = self.get_string_width(f"> {store}") + 4
        self.set_xy(MAIN_X + MAIN_W - PAD - sw - 1, y + 2)
        self.cell(sw, 4, f"> {store}")

        cy = y + 7
        # Desc
        self.set_font("Helvetica", "", 8.5)
        self.set_text_color(*BODY)
        for line in self._wrap_text(desc, MAIN_W - PAD * 2 - 8, 8.5):
            self.set_xy(MAIN_X + PAD + 5, cy)
            self.cell(MAIN_W - PAD * 2 - 8, 3.5, line)
            cy += 3.5

        cy += 1.5
        # Stack
        self.set_font("Helvetica", "B", 7.5)
        self.set_text_color(*DARK)
        self.set_xy(MAIN_X + PAD + 5, cy)
        sw2 = self.get_string_width("Stack: ")
        self.cell(sw2, 3.5, "Stack: ")

        self.set_font("Helvetica", "", 7.5)
        self.set_text_color(*MUTED)
        for i, line in enumerate(self._wrap_text(stack, MAIN_W - PAD * 2 - 8 - sw2, 7.5)):
            if i == 0:
                self.set_xy(MAIN_X + PAD + 5 + sw2, cy)
            else:
                self.set_xy(MAIN_X + PAD + 5, cy)
            self.cell(MAIN_W - PAD * 2 - 5, 3.5, line)
            cy += 3.5

        self._main_y = y + box_h + 3

    def circle(self, x, y, r, style="F"):
        self.ellipse(x - r, y - r, r * 2, r * 2, style)


# ── Build ─────────────────────────────────────────────────────────────────────

def build():
    pdf = Resume()
    pdf.build_header()
    pdf.build_sidebar_bg()

    # ── SIDEBAR ─────────────────────────────────────────────────
    pdf._sidebar_y = TOP + 2

    pdf.s_section_title("Technical Skills")
    for name, pct in SKILLS:
        pdf.s_skill_bar(name, pct)
    pdf._sidebar_y += 3

    pdf.s_section_title("Tools & Stack")
    all_tools = TOOLS_PRIMARY + TOOLS_SECONDARY
    pdf.s_tag_cloud(all_tools, primary_items=TOOLS_PRIMARY)
    pdf._sidebar_y += 1

    pdf.s_section_title("Engineering Practices")
    for pr in PRACTICES:
        y = pdf._sidebar_y
        pdf.set_fill_color(*ACCENT)
        pdf.circle(PAD + 1.2, y + 2.2, 1, "F")
        pdf.set_font("Helvetica", "", 8)
        pdf.set_text_color(*BODY)
        pdf.set_xy(PAD + 4, y)
        pdf.cell(SIDEBAR_W - PAD * 2 - 4, 4.5, pr)
        pdf._sidebar_y = y + 4.5
    pdf._sidebar_y += 2

    pdf.s_section_title("Languages")
    for lang, lv in LANGUAGES:
        pdf.s_lang(lang, lv)
    pdf._sidebar_y += 2

    pdf.s_section_title("Availability")
    pdf.s_text("Open to Freelance & Full-time", fs=8.5, bold=True, color=ACCENT)
    pdf.s_text("opportunities worldwide.", fs=8.5, color=DARK)

    # ── MAIN ────────────────────────────────────────────────────
    pdf._main_y = TOP + 2

    pdf.m_section_title("Professional Summary")
    pdf.m_text(SUMMARY, fs=9, color=BODY, line_h=4.2)
    pdf._main_y += 3

    pdf.m_section_title("Work Experience")
    for exp in EXPERIENCE:
        pdf.m_exp_header(exp["role"], exp["period"])
        pdf.m_text(exp["company"], fs=8.5, color=MUTED)
        pdf._main_y += 1.5
        for b in exp["bullets"]:
            pdf.m_bullet(b)
        pdf._main_y += 3

    pdf.m_section_title("Key Projects")
    for proj in PROJECTS:
        pdf.m_project(proj["title"], proj["store"], proj["desc"], proj["stack"])

    pdf.output(OUT)
    print(f"  ✓  PDF saved → {OUT}")


if __name__ == "__main__":
    build()
