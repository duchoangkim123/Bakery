<!-- #include file="connect.asp" -->
<!--#include file="layouts/header.asp"-->
<%
On Error Resume Next
' handle Error
Sub handleError(message)
    Session("Error") = message
    'send an email to the admin
    'Write the error message in an application error log file
End Sub
If (Request.ServerVariables("REQUEST_METHOD") = "POST") THEN
     Dim TenTK, MatKhau, TenKH, DiaChi, NgaySinh, GioiTinh, SDT
     TenTK = Request.Form("TenTK")
     MatKhau = Request.Form("MatKhau")
     TenKH = Request.Form("TenKH")
     tinh = Request.Form("Tinh")
     huyen = Request.Form("Huyen")
     xa = Request.Form("Xa")
     so_nha = Request.Form("AddressDetails")
     DiaChi = so_nha&","&xa&","&huyen&","&tinh
     NgaySinh = Request.Form("NgaySinh")
     GioiTinh = Request.Form("GioiTinh")
     SDT = Request.Form("SDT")
     ' code here to retrive the data from taikhoan table
     Dim sqlString, rs
     Set cmdPrep = Server.CreateObject("ADODB.Command")
     connDB.Open()
     cmdPrep.ActiveConnection = connDB
     cmdPrep.CommandType = 1
     cmdPrep.Prepared = True
     cmdPrep.CommandText = "SELECT TenTK FROM TAIKHOAN WHERE TenTK =?"
     cmdPrep.parameters.Append cmdPrep.createParameter("TenTK",202,1,100,TenTK)
     set rs = cmdPrep.execute
    If  rs.EOF Then      
         If (NOT isnull(TenTK) AND NOT isnull(MatKhau) AND TRIM(TenTK)<>"" AND TRIM(MatKhau)<>"" AND NOT isnull(TenKH) AND NOT isnull(DiaChi) AND NOT isnull(NgaySinh) AND NOT isnull(GioiTinh) AND NOT isnull(SDT) AND TRIM(TenTK)<>"" AND TRIM(DiaChi)<>"" AND TRIM(NgaySinh)<>"" AND TRIM(GioiTinh)<>"" AND TRIM(SDT)<>"") Then
           ' true
           ' Dim sql
           ' sql = "INSERT INTO TAIKHOAN(email,password) VALUES(?,?)"
           ' Dim cmdPrep
           ' set cmdPrep = Server.CreateObject("ADODB.Command")
           ' connDB.Open()
           ' cmdPrep.ActiveConnection = connDB
           ' cmdPrep.CommandType=1
           ' cmdPrep.Prepared=true
           ' cmdPrep.CommandText = sql
           ' cmdPrep.Parameters.Append cmdPrep.createParameter("email",202,1,255,email)
           ' cmdPrep.parameters.Append cmdPrep.createParameter("password",202,1,255,password)
           ' Dim result
           ' set result = cmdPrep.execute()
            if (NOT isnull(TenTK) and TenTK<>"" and NOT isnull(MatKhau) and MatKhau<>"" and NOT isnull(TenKH) and TenKH<>"" and NOT isnull(DiaChi) and DiaChi<>"" and NOT isnull(NgaySinh) and NgaySinh<>"" and NOT isnull(GioTinh) and GioiTinh<>"" and NOT isnull(SDT) and SDT<>"") then
                Dim cmdTaiKhoan
                Set cmdTaiKhoan = Server.CreateObject("ADODB.Command")
                cmdTaiKhoan.ActiveConnection = connDB
                cmdTaiKhoan.CommandType = 1
                cmdTaiKhoan.Prepared = True
                cmdTaiKhoan.CommandText = "INSERT INTO TAIKHOAN(TenTK,MatKhau) VALUES(?,?)"
                cmdTaiKhoan.parameters.Append cmdTaiKhoan.createParameter("TenTK",202,1,100,TenTK)
                cmdTaiKhoan.parameters.Append cmdTaiKhoan.createParameter("MatKhau",202,1,100,MatKhau)
                Dim result, id
                Set result = cmdTaiKhoan.execute

                Set id = connDB.execute("SELECT @@IDENTITY AS NewID FROM TAIKHOAN")
                IdTaiKhoan = id("NewID")                                
                if NOT id.EOF Then
                       Dim cmdKhachHang
                       Set cmdKhachHang = Server.CreateObject("ADODB.Command")
                       cmdKhachHang.ActiveConnection = connDB
                       cmdKhachHang.CommandType = 1
                       cmdKhachHang.Prepared = True         
                       cmdKhachHang.CommandText = "INSERT INTO KHACHHANG(TenKH,DiaChi,NgaySinh,GioiTinh,Email, SDT, Id) VALUES(?,?,?,?,?,?,?)"
                       cmdKhachHang.parameters.Append cmdKhachHang.createParameter("TenKH",202,1,100,TenKH)
                       cmdKhachHang.parameters.Append cmdKhachHang.createParameter("DiaChi",202,1,100,DiaChi)
                       cmdKhachHang.parameters.Append cmdKhachHang.createParameter("NgaySinh",7,1,10,NgaySinh)
                       cmdKhachHang.parameters.Append cmdKhachHang.createParameter("GioiTinh",202,1,10,GioiTinh)
                       cmdKhachHang.parameters.Append cmdKhachHang.createParameter("Email",202,1,100,TenTK)
                       cmdKhachHang.parameters.Append cmdKhachHang.createParameter("SDT",202,1,20,SDT)
                       cmdKhachHang.parameters.Append cmdKhachHang.createParameter("Id",3,1,,IdTaiKhoan)
                       cmdKhachHang.execute                      
                       
                       Session("Success") = "New account added!"
                       Response.redirect("login.asp")
                Else
                      result.Close()
                      Session("Error") = "Tài Khoản không thêm thành công"   
                End If       
            else
                Session("Error") = "You have to input enough info"                
            end if
            'kiem tra ket qua result o day
            If Err.Number=0 Then
                    Session("Success") = "The employee was added"
                    Response.redirect("login.asp")
                Else
                    handleError(Err.Description)
                End If
                On Error Goto 0
            result.Close()
            connDB.Close()
        Else
             ' false
             Session("Error") = "Please input email and password."
        End if
    Else  
       rs.Close()     
       Session("Error") = "Email đã có rồi"
    End if
          Session("Error") = "Lỗi"
    End If  
%>
<div class="container form-signup">
    <form method="post">
        <div class="mb-3">
            <label for="user_name" class="form-label">Tên khách hàng</label>
            <input type="text" class="form-control" id="user_name" name="TenKH">
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="text" class="form-control" id="email" name="TenTK">
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="MatKhau">
        </div>
        <div class="mb-3">
            <label for="address">Tỉnh/Thành phố</label>
            <input type="text" class="form-control" id="Tinh" name="Tinh" placeholder="Nhập tên tỉnh/thành phố!" value="<%=tinh%>" required>
            <div class="invalid-feedback">
              Please enter your shipping address.
            </div>
          </div>

          <div class="row">
            <div class="col-md-5 mb-3">
              <label for="country">Quận/Huyện</label>
              <input type="text" class="form-control" id="Quan" name="Huyen" placeholder="Nhập tên quận/huyện" value="<%=huyen%>" required>
              <div class="invalid-feedback">
                Please select a valid country.
              </div>
            </div>

            <div class="col-md-4 mb-3">
              <label for="state">Phường/Xã</label>
              <input type="text" class="form-control" id="Phuong" name="Xa" placeholder="Nhập tên phường/xã" value="<%=xa%>" required>
              <div class="invalid-feedback">
                Please provide a valid state.
              </div>
            </div>

            <div class="col-md-3 mb-3">
              <label for="zip">Số nhà</label>
              <input type="text" class="form-control" id="AddressDetails" name="AddressDetails" placeholder="Số nhà" value="<%=so_nha%>" required>
              <div class="invalid-feedback">
                Zip code required.
              </div>
            </div>
        </div>
        <div class="mb-3">
            <label for="DoB" class="form-label">Ngày sinh</label>
            <input type="date" class="form-control" id="date" name="NgaySinh">
        </div>
        <div class="mb-3">
            <!-- <label for="gender" class="form-label">Giới tính</label>
            <div class="gender-chosen">
                <span class="gender">
                    <label class="gender">Nam</label>
                    <input type="radio" id="male" name="gender">
                </span>
                <span class="gender female">
                    <label class="gender female">Nữ</label>
                    <input type="radio" id="female" name="gender">
                </span>
            </div> -->
            <label for="gender" class="form-label">Giới tính:</label>
            <label class="radio-inline gender">
                <input type="radio" id="male" name="GioiTinh" value="Nam" checked>Nam
            </label>
            <label class="radio-inline gender">
                <input type="radio" id="female" name="GioiTinh" value="Nữ">Nữ
            </label>
        </div>
        <div class="mb-3">
            <label for="phone" class="form-label">Số điện thoại</label>
            <input type="text" class="form-control" id="phone" name="SDT">
        </div>
        <div class="mb-3 pt-3"> 
            <button type="submit" class="btn-signup">Đăng ký</button>
        </div>
    </form>
</div>
<!--#include file="layouts/footer.asp"-->