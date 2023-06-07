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
            cmdPrep.CommandText = "SELECT * FROM NHANVIEN WHERE MaNV=?"
            ' cmdPrep.parameters.Append cmdPrep.createParameter("MaNV",3,1, ,id)
            cmdPrep.Parameters(0)=id
            Set Result = cmdPrep.execute 

            If not Result.EOF then
                TenNV = Result("TenNV")
                Email = Result("Email")
                SDT = Result("SDT")
                DiaChi = Result("DiaChi")
                GioiTinh = Result("GioiTinh")
                CCCD = Result("CCCD")
                NgaySinh = Result("NgaySinh")                
            End If

            ' Set Result = Nothing
            Result.Close()
        End If
    Else
        id = Request.QueryString("id")
        PostTenNV = Request.form("name")
        PostEmail = Request.form("email")
        PostSDT = Request.form("SDT")
        PostDiaChi = Request.form("address")
        PostGioiTinh = Request.form("StatusOption")
        PostCCCD = Request.form("CCCD")
        PostNgaySinh = Request.form("NgaySinh")

            if (NOT isnull(PostTenNV) and PostTenNV<>"" and NOT isnull(PostEmail) and PostEmail<>"" and NOT isnull(PostSDT) and PostSDT<>"" and NOT isnull(PostDiaChi) and PostDiaChi<>"" and NOT isnull(PostGioiTinh) and PostGioiTinh<>"" and NOT isnull(PostCCCD) and PostCCCD<>"" and NOT isnull(PostNgaySinh) and PostNgaySinh<>"") then
                Set cmdPrep = Server.CreateObject("ADODB.Command")
                connDB.Open()                
                cmdPrep.ActiveConnection = connDB
                cmdPrep.CommandType = 1
                cmdPrep.Prepared = True
                cmdPrep.CommandText = "UPDATE SANPHAM SET TenNV=?,Email=?,SDT=?,DiaChi=?,GioiTinh=?,CCCD=?,NgaySinh=? WHERE MaNV=?"
                cmdPrep.parameters.Append cmdPrep.createParameter("name",202,1,50,PostTenNV)
                cmdPrep.parameters.Append cmdPrep.createParameter("email",202,1,100,PostEmail)
                cmdPrep.parameters.Append cmdPrep.createParameter("phone",202,1,20,PostSDT)
                cmdPrep.parameters.Append cmdPrep.createParameter("address",202,1,100,PostDiaChi)
                cmdPrep.parameters.Append cmdPrep.createParameter("gender",202,1,10,PostGioiTinh)
                cmdPrep.parameters.Append cmdPrep.createParameter("CCCD",202,1,20,PostCCCD)
                cmdPrep.parameters.Append cmdPrep.createParameter("date",7,1,10,PostNgaySinh)
                cmdPrep.parameters.Append cmdPrep.createParameter("MaNV",3,1, ,id)

                cmdPrep.execute
                If Err.Number=0 Then
                    Session("Success") = "Sản phẩm đã được sửa thông tin!!!"
                    Response.redirect("ProductManagement.asp")
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
        <h2>Sửa thông tin nhân viên</h2>
        
        <form method="post">
            <div class="mb-3">
                <label for="name" class="form-label">Tên nhân viên</label>
                <input type="text" class="form-control" id="name" name="name" value="<%=TenNV%>">
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="text" class="form-control" id="email" name="email" value="<%=Email%>">
            </div>
            <div class="mb-3">
                <label for="phone" class="form-label">SDT</label>
                <input type="text" class="form-control" id="phone" name="phone" value="<%=SDT%>">
            </div>
            <div class="mb-3">
                <label for="address" class="form-label">Dịa chỉ</label>
                <input type="text" class="form-control" id="address" name="address" value="<%=DiaChi%>">
            </div>            
            <div class="mb-3">
                <label for="gender" class="form-label">Tình trạng:</label>
                <div class="uk-form-controls">
                    <% For Each StatusOption in statusOptions %>
                        <% If StatusOption = GioiTinh Then %>
                        <label><input class="uk-radio" type="radio" name="StatusOption" value="<%= StatusOption %>" checked> <%= StatusOption %></label><br>
                        <% Else %>
                        <label><input class="uk-radio" type="radio" name="StatusOption" value="<%= StatusOption %>"> <%= StatusOption %></label><br>
                        <% End If %>
                    <% Next %>
                </div>            
            </div>  
            <div class="mb-3">
                <label for="CCCD" class="form-label">Hình ảnh</label>
                <input type="text" class="form-control" id="CCCD" name="CCCD" value="<%=CCCD%>">
            </div>
            <div class="mb-3">
                <label for="date" class="form-label">Hình ảnh</label>
                <input type="text" class="form-control" id="date" name="date" value="<%=NgaySinh%>">
            </div>
            <button type="submit" class="btn btn-primary">Cập nhật</button>
            <a href="EmployeeManagement.asp" class="btn btn-info">Hủy</a>               
        </form>
    </div>
<!-- #include file="layouts/footer.asp" -->