# OOAD_Quan_ly_ban_cafe
 Dự án quản lý quán cafe được xây dựng bằng Python (Flask) dựa trên phân tích thiết kế hệ thống hướng đối tượng (OOAD).

## 1. Thành phần dự án
- **Backend:** Flask (Python)
- **Database:** SQL Server (sử dụng file SQLQuery1.sql để tạo cấu trúc)
- **Frontend:** HTML/CSS

## 2. Cấu trúc thư mục chính
- `/models`: Chứa các lớp đối tượng (Sản phẩm, Hóa đơn, Bàn...)
- `/static`: Các file CSS, hình ảnh, Javascript.
- `/templates`: Các giao diện người dùng.
- `app.py`: File chạy chính của ứng dụng.
- `config.py`: Cấu hình kết nối cơ sở dữ liệu.

## 3. Cách cài đặt và chạy
1. Tạo môi trường ảo:
   Xóa file .venv khi vừa tải dự án về
   rồi tạo lại file .venv mới
3. Kích hoạt môi trường và cài đặt thư viện:
  pip install -r requirements.txt
4. Chạy ứng dụng:
  python app.py
5. Chạy web của khách hàng:
  chạy app.py sau đó nhập vào trình duyệt đường dẫn: "đường dẫn API tạo"/menu/"số bàn"
  ví dụ: http://127.0.0.1:5000/menu/01
