<!-- #include file="connect.asp" -->
<%
On Error Resume Next
' handle Error
Sub handleError(message)
    Session("Error") = message
    'send an email to the admin
    'Write the error message in an application error log file
End Sub
        ' Yêu cầu đăng nhập để thêm sửa xóa
    ' If (isnull(Session("email")) OR TRIM(Session("email")) = "") Then
    '     Response.redirect("login.asp")
    ' End If
    Dim statusOptions
    statusOptions = Array("Nam", "Nữ")

    If (Request.ServerVariables("REQUEST_METHOD") = "GET") THEN        
        id = Request.QueryString("id")
        
        If (cint(id)<>0) Then
            Set cmdPrep = Server.CreateObject("ADODB.Command")
            connDB.Open()
            cmdPrep.ActiveConnection = connDB
            cmdPrep.CommandType = 1
            cmdPrep.CommandText = "SELECT * FROM KHACHHANG WHERE MaKH=?"
            ' cmdPrep.parameters.Append cmdPrep.createParameter("MaKH",3,1, ,id)
            cmdPrep.Parameters(0)=id
            Set Result = cmdPrep.execute 

            If not Result.EOF then
                TenKH = Result("TenKH")
                DiaChi = Split(Result("DiaChi"), ",")
                so_nha = DiaChi(0)
                xa = DiaChi(1)
                huyen = DiaChi(2)
                tinh = DiaChi(3)           
                NgaySinh = Result("NgaySinh")
                GioiTinh = Result("GioiTinh")
                Email = Result("Email")
                SDT = Result("SDT")              
            End If

            ' Set Result = Nothing
            Result.Close()
        End If
    Else
        id = Request.QueryString("id")
        PostTenKH = Request.form("name")
        tinh = Request.Form("Tinh")
        huyen = Request.Form("Huyen")
        xa = Request.Form("Xa")
        so_nha = Request.Form("AddressDetails")
        PostDiaChi = so_nha&","&xa&","&huyen&","&tinh
        PostNgaySinh = Request.form("gender")
        PostGioiTinh = Request.form("StatusOption")
        PostEmail = Request.form("Email")
        PostSDT = Request.form("phone")

            if (NOT isnull(PostTenKH) and PostTenKH<>"" and NOT isnull(PostDiaChi) and PostDiaChi<>"" and NOT isnull(PostNgaySinh) and PostNgaySinh<>"" and NOT isnull(PostGioiTinh) and PostGioiTinh<>"" and NOT isnull(PostEmail) and PostEmail<>"" and NOT isnull(PostSDT) and PostSDT<>"" ) then
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()                
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "UPDATE SANPHAM SET TenKH=?,DiaChi=?,NgaySinh=?,GioiTinh=?,Email=?,SDT=? WHERE MaKH=?"
                cmdPrep.parameters.Append cmdPrep.createParameter("name",202,1,50,PostTenKH)
                cmdPrep.parameters.Append cmdPrep.createParameter("address",202,1,100,PostDiaChi)
                cmdPrep.parameters.Append cmdPrep.createParameter("date",202,1,20,PostNgaySinh)
                cmdPrep.parameters.Append cmdPrep.createParameter("gender",202,1,100,PostGioiTinh)
                cmdPrep.parameters.Append cmdPrep.createParameter("Email",202,1,10,PostEmail)
                cmdPrep.parameters.Append cmdPrep.createParameter("phone",202,1,20,PostSDT)
                cmdPrep.parameters.Append cmdPrep.createParameter("MaKH",3,1, ,id)

                cmdPrep.execute
                If Err.Number=0 Then
                    Session("Success") = "Khách hàng đã được sửa thông tin!!!"
                    Response.redirect("CustomerManagement.asp")
                Else
                    handleError(Err.Description)
                End If
                On Error Goto 0
            else
                Session("Error") = "Các trường dữ liệu không được để trống!!!"
            end if
        end if
    
%>
<!-- #include file="layouts/header.asp" -->
    <div class="container">
        <h2>Sửa thông tin khách hàng</h2>
        <%
        Dim sqlstring
        sqlstring = "KhachHang" 'Dat ten bien sqlstring co gia tri la KhachHang'
        Set cmdTaiKhoan = Server.CreateObject("ADODB.Command")
        connDB.Open()
        cmdTaiKhoan.ActiveConnection = connDB
        cmdTaiKhoan.CommandType = 1
        cmdTaiKhoan.CommandText = "SELECT * FROM TAIKHOAN WHERE TenTK !=? AND VaiTro = ? AND Id NOT IN (SELECT Id FROM KHACHHANG)"
        ' cmdPrep.parameters.Append cmdPrep.createParameter("MaNV",3,1, ,id)
        cmdTaiKhoan.Parameters(0)=Email
        cmdTaiKhoan.Parameters(1)=sqlstring
        Set Result = cmdTaiKhoan.execute

        %>
        <form method="post">
            <div class="mb-3">
                <label for="name" class="form-label">Tên khách hàng</label>
                <input type="text" class="form-control" id="name" name="name" value="<%=TenKH%>">
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
                <label for="date" class="form-label">Ngày sinh</label>
                <input type="date" class="form-control" id="date" name="date" value="<%=NgaySinh%>">
            </div>
            <div class="mb-3">
                <label for="gender" class="form-label">Giới tính:</label>
                <div class="uk-form-controls">
                    <% For Each StatusOption in statusOptions %>
                        <% If StatusOption = GioiTinh Then %>
                        <label><input class="uk-radio" type="radio" name="StatusOption" value="<%= StatusOption %>" checked> <%= StatusOption %></label>
                        <% Else %>
                        <label><input class="uk-radio" type="radio" name="StatusOption" value="<%= StatusOption %>"> <%= StatusOption %></label>
                        <% End If %>
                    <% Next %>
                </div>            
            </div>  
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <select name="Email" class="form-control">
                   <option value="<%=Email%>"><%=Email%></option>
                   <% do while not Result.EOF %>
                   <option value="<%=Result("TenTK")%></option>"><%=Result("TenTK")%></option>
                   <%
                       Result.MoveNext
                       loop
                   %>
                </select>
            </div>                          
            <div class="mb-3">
                <label for="phone" class="form-label">SDT</label>
                <input type="text" class="form-control" id="phone" name="phone" value="<%=SDT%>">
            </div>
            <button type="submit" class="btn btn-primary">Cập nhật</button>
            <a href="CustomerManagement.asp" class="btn btn-info">Hủy</a>               
        </form>
    </div>
<!-- #include file="layouts/footer.asp" -->