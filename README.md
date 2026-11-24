# ✨ Antigravity Custom Theme Skill — Bản Mở Rộng (Extended Edition)

> [!IMPORTANT]
> ### 🙏 Ghi Nguồn & Tri Ân Tác Giả Gốc (Credits & Attribution)
> Dự án này được kế thừa và phát triển trực tiếp từ công trình mã nguồn mở gốc của tác giả **Gia Kiệt (`giakiet22102006`)**:
> - **Kho mã nguồn gốc (Original Repository):** [https://github.com/giakiet22102006/antigravity-custom-theme-skill](https://github.com/giakiet22102006/antigravity-custom-theme-skill)
> - **Kiến trúc lõi của tác giả gốc:** Engine tiêm giao diện qua giao thức CDP (Chrome DevTools Protocol), thuật toán kính mờ tiền xử lý **Zero Live Blur 60/120fps** (`syncPrebakedGlass`), cơ chế cắt khung trình duyệt nhúng thông minh (`Split-Browser Cutout`), trình chạy ngầm đa nền tảng (`daemon/theme_daemon.js`) và cấu trúc **AI Agent Skill** (`SKILL.md`).
> - **Bản Mở Rộng (Extended Edition)** do **Châu Vũ Long (`Catlikechili`)** đóng gói bổ sung 6 bộ giao diện hoàn chỉnh, biên dịch sẵn payload chạy ngay không cần Python/Pillow, vá lỗi hiển thị thanh bên trên Antigravity v2.33.0+ và tự động hoá cài đặt 1 câu lệnh cho máy mới theo giấy phép **MIT License**. Xin gửi lời cảm ơn chân thành đến tác giả **Gia Kiệt (`giakiet22102006`)** vì nền tảng kỹ thuật xuất sắc này!

Biến mọi bức ảnh nền, phong cách thẩm mỹ hoặc bảng màu yêu thích thành giao diện kính mờ (**Glassmorphic UI**) mượt **60–120fps** ngay bên trong **Google Antigravity** — hoạt động đồng thời như một **Bộ Engine Giao Diện Độc Lập** và một **Kỹ Năng AI Agent (`SKILL.md`)** tự động thiết kế theme theo yêu cầu, tuyệt đối không can thiệp hay chỉnh sửa tệp nhị phân gốc của ứng dụng Electron.

---

## 🚀 Điểm Mới Nổi Bật Trong Bản Mở Rộng (Extended Edition)

1. **Đóng Gói Sẵn `dist/theme_payload.js` (Chạy Ngay Không Cần Build):**
   - Tệp thực thi `dist/theme_payload.js` chứa toàn bộ Engine + 6 bộ theme + hình nền WebP 2K & huy hiệu SVG đã được biên dịch sẵn trong Git. Khi cài sang máy mới, giao diện hoạt động **ngay lập tức mà không cần cài Python hay thư viện Pillow**.
2. **Trình Cài Đặt Tự Động 1 Câu Lệnh Cho Máy Mới (`scripts/bootstrap-win.ps1`):**
   - Chỉ với 1 dòng lệnh PowerShell duy nhất, kịch bản tự động kiểm tra và cài đặt **Git** + **Node.js >= 22 LTS** qua `winget` nếu máy chưa có, tự làm mới `PATH`, tải bộ kỹ năng về đúng thư mục chuẩn `%USERPROFILE%\.gemini\config\skills\antigravity-custom-theme` và kích hoạt dịch vụ chạy ngầm.
3. **Khắc Phục Triệt Để Lỗi Ẩn Nút Trên Antigravity v2.33.0+ (`.bg-sidebar` Fix):**
   - Sửa cơ chế dò tìm thanh điều hướng khi Antigravity v2.33.0+ sinh nhiều phần tử `.bg-sidebar` cùng lúc, đảm bảo nút **`✨ Custom theme`** luôn xuất hiện ổn định ở thanh bên trái (ngay bên dưới mục `Customizations`).
4. **6 Bộ Giao Diện Kính Mờ Cao Cấp Tích Hợp Sẵn (6 Built-in Glassmorphic Presets):**

| # | Tên Giao Diện (Preset) | Chế Độ & Bảng Màu Chủ Đạo | Điểm Nhấn Thiết Kế & Tài Nguyên Đi Kèm |
| :-: | :--- | :--- | :--- |
| **1** | **`WLOP Cosmic`** | **Dark Glass** (`#fbbf24` Vàng Sao Băng • `#38bdf8` Lam Vũ Trụ) | Hình nền bầu trời sao nghệ thuật 2K (`wlop_cosmic_2k.webp`) kết hợp hoa văn góc viền & huy hiệu khung nhập liệu SVG cổ điển. |
| **2** | **`Midnight Obsidian`** | **Dark Pure-CSS** (`#a78bfa` Tím Thạch Anh • `#38bdf8` Xanh Băng) | Thuần CSS đa lớp chuyển sắc (`pureBg` 0 KB ảnh), siêu nhẹ, tối giản và sắc nét tuyệt đối cho phiên làm việc dài. |
| **3** | **`Cyberpunk Neon Matrix`** | **Dark HUD Glass** (`#00f5d4` Điện Quang Cyan • `#f72585` Hồng Magenta) | Không gian lưới Cyberpunk 2K (`cyber_neon_2k.webp`), góc viền HUD, nhãn dán khung chat và bộ đôi Avatar SVG riêng cho User & AI. |
| **4** | **`Kyoto Matcha Zen`** | **Light Glass (`isLight: true`)** (`#10b981` Xanh Trà Đạo • `#d97706` Vàng Tre) | Giao diện kính mờ **nền sáng ban ngày** với mực chữ tối sắc nét (`#0f172a`), tranh màu nước Matcha 2K dịu mắt và hoa sen SVG thanh tịnh. |
| **5** | **`Argon Commander Gold`** | **Dark Signature CSS** (`#f59e0b` Vàng Hổ Phách • `#8b5cf6` Tím Lượng Tử) | Giao diện đặc trưng của **Gemini 4 Argon** — nền chuyển sắc đa tầng sang trọng đi kèm huy hiệu vương miện Argon & Avatar chỉ huy SVG. |
| **6** | **`Sakura Twilight Glass`** | **Dark Cozy Dusk** (`#fb7185` Hồng Anh Đào • `#818cf8` Chàm Hoàng Hôn) | Bầu trời chiều tà cùng cánh hoa anh đào phát sáng 2K (`sakura_twilight_2k.webp`) và huy hiệu cánh hoa SVG ấm áp. |

### Công Nghệ Cốt Lõi Kế Thừa Từ Engine Gốc
- **Kiến Trúc Zero Live Blur (Cuộn Mượt 60–120fps):** Tiền xử lý hiệu ứng kính mờ một lần trên Offscreen Canvas (`syncPrebakedGlass`) thay vì dùng CSS `backdrop-filter: blur()` trực tiếp, loại bỏ hoàn toàn hiện tượng tụt khung hình GPU trên Electron.
- **Tự Động Cắt Khung Trình Duyệt Nhúng (`Split-Browser Safe`):** Tự nhận diện khung trình duyệt chia đôi bên phải (`data-has-browser-hole`) và cắt vùng trong suốt bằng `evenodd clip-path` để trang web kiểm thử không bao giờ bị ám màu hay mờ nhoè.
- **Chạy Ngầm Nhẹ Nhàng & Hot-Reload:** Sử dụng `WebSocket` gốc có sẵn trong **Node.js >= 22** (không cần `npm install` bất kỳ thư viện ngoài nào).

---

## 📖 Hướng Dẫn Sử Dụng Chi Tiết (Từ A đến E)

### (A) Cài Đặt Nhanh 1 Câu Lệnh Trên Máy Mới

#### Cách 1: Cài tự động 1 dòng lệnh duy nhất trên Windows *(Khuyên dùng)*
Mở **PowerShell** và dán câu lệnh sau rồi nhấn **Enter**:

```powershell
irm https://raw.githubusercontent.com/Catlikechili/antigravity-custom-theme-skill/main/scripts/bootstrap-win.ps1 | iex
```

**Kịch bản này sẽ tự động thực hiện trọn gói:**
1. Kiểm tra **Git** và **Node.js >= 22 LTS**; nếu máy mới chưa có sẽ tự cài đặt âm thầm qua `winget` và nạp lại `PATH`.
2. Tải kho mã nguồn (hoặc cập nhật bản mới nhất) vào đúng thư mục kỹ năng toàn cục: `%USERPROFILE%\.gemini\config\skills\antigravity-custom-theme`.
3. Sử dụng ngay tệp `dist/theme_payload.js` đã đóng gói sẵn, vá cờ `--remote-debugging-port=0` vào các biểu tượng khởi động `Antigravity.lnk`, tạo trình khởi chạy ẩn cùng Windows (`AntigravityCustomTheme.lnk`) và kích hoạt giao diện ngay lập tức.

#### Cách 2: Cài đặt thủ công qua `git clone`

**Trên Windows (PowerShell):**
```powershell
git clone https://github.com/Catlikechili/antigravity-custom-theme-skill.git "$env:USERPROFILE\.gemini\config\skills\antigravity-custom-theme"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\config\skills\antigravity-custom-theme\scripts\install-win.ps1"
```
- Tuỳ chọn bổ sung cho `install-win.ps1`:
  - Thêm `-NoStartup` nếu chỉ muốn chạy trong phiên hiện tại (không tự bật cùng Windows).
  - Thêm `-ForceBuild` nếu muốn ép biên dịch lại `dist/theme_payload.js` từ mã nguồn bằng Python.

**Trên macOS / Linux (Bash):**
```bash
git clone https://github.com/Catlikechili/antigravity-custom-theme-skill.git ~/.gemini/config/skills/antigravity-custom-theme
bash ~/.gemini/config/skills/antigravity-custom-theme/scripts/install-unix.sh
```
- Trên **macOS**, kịch bản cài đặt `LaunchAgent` tại `~/Library/LaunchAgents/io.antigravity.custom-theme.plist`.
- Trên **Linux**, kịch bản cài đặt dịch vụ `systemd --user` (hoặc chuyển sang `nohup`).

#### Kiểm tra trạng thái hoạt động trực tiếp (CDP Diagnostic)
```powershell
node "$env:USERPROFILE\.gemini\config\skills\antigravity-custom-theme\scripts\verify_cdp.js"
```

---

### (B) Cách Mở Bảng Custom Theme Studio & Đổi Ảnh Nền, Độ Tối, Độ Mờ, Avatar

Sau khi cài đặt, bạn có **2 cách mở nhanh** bảng điều khiển **Custom Theme Studio** ngay trong giao diện Antigravity:
1. **Cách nhanh nhất:** Nhìn sang thanh điều hướng bên trái (Left Sidebar), nhấn vào mục **`✨ Custom theme`** nằm ngay bên dưới mục `Customizations`.
2. **Qua Cài đặt:** Mở **`Settings` -> `Appearance` -> nhấn nút màu cam vàng `Open Custom Theme Studio`**.

Bên trong cửa sổ **Custom Theme Studio**, mọi thao tác đều áp dụng trực tiếp theo thời gian thực và tự lưu vào `theme_config.json`:

- **Đổi Ảnh Nền Riêng (`Custom Image`) & Bật/Tắt Nền (`Backdrop`):**
  - Nhấn nút **`Custom Image`** ở khung trên cùng để tải bất kỳ bức ảnh `.png`, `.jpg`, `.webp` nào từ máy tính lên làm hình nền.
  - Tích hoặc bỏ tích ô **`Backdrop`** để bật/tắt nhanh lớp hình nền.
- **Chỉnh Độ Tối Lớp Phủ (`Dim`: `15%` – `92%`):**
  - Kéo thanh trượt **`Dim`** sang phải nếu ảnh nền quá sáng để tăng độ tương phản cho chữ trong khung chat; kéo sang trái nếu muốn ngắm rõ chi tiết tranh nền hơn.
- **Chỉnh Độ Mờ Kính (`Blur`: `0px` – `16px`):**
  - Kéo thanh trượt **`Blur`** để tinh chỉnh độ nhám mờ của thanh tiêu đề và thanh bên trái (sử dụng thuật toán *Pre-Baked Blur* nên kéo lên `16px` vẫn cuộn trang mượt 60–120fps).
- **Đổi Ảnh Đại Diện Trò Chuyện (`Chat Avatars — User & Agent`):**
  - Tại khung **Chat Avatars (User & AI Agent)**, nhấn nút **`User`** (ảnh của bạn) hoặc **`Agent`** (ảnh của AI) để tải ảnh từ máy tính lên — hệ thống sẽ tự động nén về chuẩn WebP siêu nhẹ. Nhấn **`Off`** nếu muốn ẩn avatar.
  - Dùng thanh trượt **`Size`** (`22px` – `52px`) để chỉnh kích thước avatar và **`Corner Radius`** (`0%` khung vuông sắc cạnh đến `50%` khung tròn hoàn hảo).
- **Phối Trộn Khung Tin Nhắn & Ô Nhập Liệu Độc Lập:**
  - Chọn **`User Chat Bubble`** và **`Composer Style`** riêng biệt với hình nền đang dùng (ví dụ: dùng nền *Sakura Twilight Glass* kết hợp khung viền vàng kim của *Argon Commander Gold*).
- **Sao Lưu / Chia Sẻ Cấu Hình (`Export JSON` / `Import JSON` / `Reset`):**
  - Nhấn **`Export JSON`** để sao chép cấu hình hiện tại, **`Import JSON`** để dán cấu hình yêu thích, hoặc **`Reset`** để đưa mọi thanh trượt về mặc định gốc.

---

### (C) Cách Ra Lệnh Cho AI Agent Tự Tạo Theme Mới Từ Ảnh Của Bạn

Vì bộ công cụ được cài đặt ngay trong thư mục kỹ năng toàn cục `~/.gemini/config/skills/antigravity-custom-theme/`, AI Agent trong Antigravity sẽ tự động nhận diện tệp `SKILL.md` và quy chuẩn `references/theme-schema.md`.

> **Lưu ý nhỏ khi tạo theme mới:** Để biên dịch thêm ảnh mới vào `dist/theme_payload.js`, máy tính cần có **Python 3.9+** (khuyến nghị cài thêm `pip install Pillow` để tự động nén ảnh lớn >2K sang định dạng `.webp` tối ưu).

Bạn chỉ cần đính kèm một bức ảnh vào khung chat của Antigravity và ra lệnh bằng tiếng Việt tự nhiên, ví dụ:
- *"Dùng skill `antigravity-custom-theme` tạo cho tôi một theme kính mờ tông xanh ngọc lục bảo Ghibli từ bức ảnh đính kèm, thiết kế thêm huy hiệu SVG góc khung chat và áp dụng luôn."*
- *"Thiết kế thêm một theme nền sáng (`isLight: true`) phong cách cà phê tối giản từ ảnh này bằng `antigravity-custom-theme`, biên dịch lại payload và kiểm tra CDP giúp tôi."*

AI Agent sẽ tự động trích xuất bảng màu hài hoà, cắt bỏ watermark góc ảnh (nếu có), sinh tệp trang trí SVG vào `themes/assets/`, cập nhật `themes/themes.json`, chạy `python scripts/build_payload.py` và tự động nạp nóng (hot-reload) lên màn hình của bạn!

---

### (D) Cách Xử Lý Khi Mất Giao Diện Sau Khi Antigravity Tự Động Cập Nhật (`--remote-debugging-port=0`)

Từ phiên bản **Antigravity v2.33.0 trở lên**, ứng dụng không còn tự mở cổng `DevToolsActivePort` nếu khởi chạy thiếu tham số `--remote-debugging-port=0`. Khi Antigravity tự cập nhật phiên bản mới, bộ cập nhật sẽ tự khởi động lại `Antigravity.exe --updated` mà bỏ qua cờ này (hoặc ghi đè lại biểu tượng ngoài màn hình), khiến daemon tạm thời chưa thể kết nối.

**Cách khắc phục triệt để trong 30 giây trên Windows:**
1. Chạy lại lệnh cài đặt để tự động vá cờ `--remote-debugging-port=0` vào toàn bộ shortcut `Antigravity.lnk` (Start Menu, Desktop, Startup, Taskbar):
   ```powershell
   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\config\skills\antigravity-custom-theme\scripts\install-win.ps1"
   ```
2. **Thoát hoàn toàn Antigravity:** Nhấp chuột phải vào biểu tượng Antigravity ở khay hệ thống góc phải dưới màn hình (**System Tray**) -> chọn **`Quit`** *(lưu ý: chỉ bấm dấu `X` đóng cửa sổ có thể chưa thoát hẳn tiến trình nền)*, sau đó mở lại **Antigravity** từ **Start Menu**.
3. **Nếu bạn mở Antigravity từ biểu tượng ghim dưới thanh Taskbar:** Hãy chuột phải **Bỏ ghim (`Unpin from taskbar`)** biểu tượng cũ, mở Start Menu tìm **Antigravity** rồi **Ghim lại vào Taskbar (`Pin to taskbar`)** để shortcut trên Taskbar giữ vĩnh viễn cờ `--remote-debugging-port=0`.

*(Trên **macOS / Linux**: khởi chạy Antigravity kèm cờ `--remote-debugging-port=0`, ví dụ `open -a Antigravity --args --remote-debugging-port=0` trên macOS hoặc thêm `--remote-debugging-port=0` vào dòng `Exec=` trong tệp `.desktop` trên Linux).*

---

### (E) Hướng Dẫn Gỡ Cài Đặt Sạch Sẽ (`uninstall.js`)

Khi muốn quay về giao diện mặc định nguyên bản của Antigravity và gỡ bỏ hoàn toàn dịch vụ chạy ngầm, chỉ cần chạy:

```powershell
node "$env:USERPROFILE\.gemini\config\skills\antigravity-custom-theme\scripts\uninstall.js"
```

**Lệnh này sẽ tự động:**
- Dừng ngay tiến trình `theme_daemon.js` đang chạy ngầm và xoá `daemon.pid` / `silent-start.vbs`.
- Gỡ bỏ biểu tượng khởi động cùng hệ thống (`AntigravityCustomTheme.lnk` trên Windows, `LaunchAgent` trên macOS, hoặc dịch vụ `systemd --user` trên Linux).
- Gửi tín hiệu qua CDP để tháo bỏ tức thì toàn bộ lớp kính mờ & khôi phục giao diện gốc trên mọi cửa sổ Antigravity đang mở mà không cần khởi động lại ứng dụng.

---

## 📂 Cấu Trúc Thư Mục Dự Án

```text
antigravity-custom-theme-skill/
├── SKILL.md                    # Định nghĩa quy trình chuẩn cho AI Agent
├── README.md                   # Tài liệu hướng dẫn tiếng Việt đầy đủ
├── LICENSE                     # Giấy phép mã nguồn mở MIT
├── references/
│   └── theme-schema.md         # Đặc tả cấu trúc themes.json & quy tắc độ tương phản
├── themes/
│   ├── themes.json             # Cấu hình chi tiết của 6 bộ giao diện tích hợp sẵn
│   └── assets/                 # Hình nền 2K (.webp), huy hiệu góc & Avatar (.svg)
├── engine/
│   └── core.js                 # Engine tiêm giao diện (Zero Live Blur + Studio Modal + Sidebar Fix)
├── daemon/
│   └── theme_daemon.js         # Trình chạy ngầm CDP đa nền tảng & lưu trữ cấu hình
├── scripts/
│   ├── bootstrap-win.ps1       # Trình cài đặt tự động 1 câu lệnh cho máy Windows mới
│   ├── install-win.ps1         # Kịch bản cài đặt, tự cài Node >= 22 & vá cờ CDP trên Windows
│   ├── install-unix.sh         # Kịch bản cài đặt cho macOS (launchd) & Linux (systemd)
│   ├── build_payload.py        # Trình biên dịch themes.json + core.js -> dist/theme_payload.js
│   ├── verify_cdp.js           # Công cụ kiểm định kết nối CDP & chất lượng hiển thị trực tiếp
│   └── uninstall.js            # Công cụ gỡ cài đặt sạch sẽ đa nền tảng
└── dist/
    └── theme_payload.js        # Payload biên dịch sẵn (theo dõi trong Git để chạy ngay không cần build)
```

---

## 📜 Giấy Phép (License)

Phát hành theo giấy phép **MIT License**:
- Bản quyền gốc: `Copyright (c) 2026 giakiet22102006` — [giakiet22102006/antigravity-custom-theme-skill](https://github.com/giakiet22102006/antigravity-custom-theme-skill)
- Bản quyền các bản vá mở rộng & gói 6 giao diện: `Modifications & Extended Theme Pack Copyright (c) 2026 Châu Vũ Long (Catlikechili)`
