<!-- #include file="connect.asp" -->
<!-- #include file="layouts/header.asp" -->
<!-- #include file="sidebar.asp" -->
<%
'Phan trang'
' ham lam tron so nguyen
    function Ceil(Number)
        Ceil = Int(Number)
        if Ceil<>Number Then
            Ceil = Ceil + 1
        end if
    end function

    function checkPage(cond, ret) 
        if cond=true then
            Response.write ret
        else
            Response.write ""
        end if
    end function
' trang hien tai

    Dim itemSearch

    itemSearch = Request.QueryString("myInput")

    page = Request.QueryString("page")
    limit = 8
    connDB.Open()
    if (trim(page) = "") or (isnull(page)) then
        page = 1
    end if

    offset = (Clng(page) * Clng(limit)) - Clng(limit)

    If (isnull(itemSearch)) or (trim(itemSearch)="") Then
       strSQL = "SELECT COUNT(MaNV) AS count FROM NHANVIEN"       
       Set CountResult = connDB.execute(strSQL)
    Else
       strSQL = "SELECT COUNT(MaNV) AS count FROM NHANVIEN WHERE TenNV LIKE N'%"&itemSearch&"%'"
       Set CountResult = connDB.execute(strSQL)
    End if

    totalRows = CLng(CountResult("count"))

    Set CountResult = Nothing
' lay ve tong so trang
    pages = Ceil(totalRows/limit)
    'gioi han tong so trang la 5
    Dim range
    If (pages<=5) Then
        range = pages
    Else
        range = 5
    End if
%>
    <div class="container-fluid">
        <div class="d-flex bd-highlight mb-3">
            <div class="me-auto p-2 bd-highlight"><h2>Danh sách nhân viên</h2></div>
            <!--Search-->

        <nav class="navbar navbar-light bg-light">

            <form class="form-inline" method="get">

                <input id="myInput" name="myInput" class="form-control mr-sm-2" type="search" placeholder="Nhập tên nhân viên" aria-label="Tìm kiếm" value="<%=itemSearch%>">

                <button class="btn btn-outline-success my-2 my-sm-0" type="submit"><i class="fa-solid fa-magnifying-glass"></i>Search</a></button>

            </form>

        </nav>
            <div class="p-2 bd-highlight">
                <a href="/AddEmployee.asp" class="btn btn-primary">Thêm nhân viên</a>
            </div>
        </div>
         
        <section class="h-100 h-custom" style="background-color: #eee;"></section>
        <div class="table-responsive">
            <table class="table table dark">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Mã nhân viên</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>SĐT</th>
                        <th>Địa chỉ</th>
                        <th>Giới tính</th>
                        <th>CCCD</th>
                        <th>Ngày sinh</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                         if(isnull(itemSearch) or trim(itemSearch) = "") Then
                            Set cmdPrep = Server.CreateObject("ADODB.Command")                      
                            cmdPrep.ActiveConnection = connDB
                            cmdPrep.CommandType = 1
                            cmdPrep.Prepared = True
                            cmdPrep.CommandText = "SELECT MaNV, TenNV, Email, SDT, DiaChi, GioiTinh, CCCD, NgaySinh FROM NHANVIEN ORDER BY MaNV OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
                            cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
                            cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)


                            Set Result = cmdPrep.execute

                          Else
                            Set cmdPrep = Server.CreateObject("ADODB.Command")
                            cmdPrep.ActiveConnection = connDB
                            cmdPrep.CommandType = 1
                            cmdPrep.Prepared = True
                            cmdPrep.CommandText = "SELECT MaNV, TenNV, Email, SDT, DiaChi, GioiTinh, CCCD, NgaySinh FROM NHANVIEN WHERE TenNV LIKE N'%"&itemSearch&"%' ORDER BY MaNV OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
                            cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
                            cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)
                     
    
                            Set Result = cmdPrep.execute
                        End if
                            Dim i     
                            i = (limit*(page-1))                        
                            do while not Result.EOF                                                    
                            i = i + 1
                    %>

                        <tr>
                            <td> <%= i %> </td>                   
                            <td><%=Result("MaNV")%></td>
                            <td><%=Result("TenNV")%></td>
                            <td><%=Result("Email")%></td>
                            <td><%=Result("SDT")%></td>
                            <td><%=Result("DiaChi")%></td>
                            <td><%=Result("GioiTinh")%></td>
                            <td><%=Result("CCCD")%></td>
                            <td><%=Result("NgaySinh")%></td>
                            <td>
                                <a href="/EditEmployee.asp?id=<%=Result("MaNV")%>" class="btn btn-secondary"><i class="fa-solid fa-pen-to-square"></i></a>
                                <a data-href="/DeleteEmployee.asp?id=<%=Result("MaNV")%>" class="btn btn-danger" data-toggle="modal" data-target="#confirm-delete" title="Delete"><i class="fa-solid fa-trash"></i></a>
                            </td>
                        </tr>

                    <%
                        Result.MoveNext
                        loop
                    %>
                </tbody>
            </table>
        </div>
    </section>

        <nav aria-label="Page Navigation">
            <ul class="pagination pagination-sm justify-content-center my-5">
                <% if (pages>1) then 
                'kiem tra trang hien tai co >=2
                        if(Clng(page)>=2) then
                %>
                        <li class="page-item"><a class="page-link" href="EmployeeManagement.asp?page=<%=Clng(page)-1%>">Previous</a></li>
                <%    
                        end if 
                        for i= 1 to pages
                %>
                            <li class="page-item <%=checkPage(Clng(i)=Clng(page),"active")%>"><a class="page-link" href="EmployeeManagement.asp?page=<%=i%>"><%=i%></a></li>
                <%
                        next
                        if (Clng(page)<pages) then
    
                %>
                        <li class="page-item"><a class="page-link" href="EmployeeManagement.asp?page=<%=Clng(page)+1%>">Next</a></li>
                <%
                        end if    
                    end if
                %>
            </ul>
        </nav>
        <!-- <div class="modal" tabindex="-1" id="confirm-delete">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc muốn xóa sản phẩm?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <a class="btn btn-danger btn-delete">Xóa</a>
                </div>
            </div>
        </div>
    </div> -->
    <div class="modal" tabindex="-1" role="dialog" id="confirm-delete">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Xác nhận xóa</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <p>Bạn có chắc muốn xóa nhân viên?</p>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
              <!-- <button type="button" class="btn btn-primary">Xóa sản phẩm</button> -->
              <a class="btn btn-danger btn-delete">Xóa</a>
            </div>
          </div>
        </div>
       </div>
      <!--END confirm delete-->
    </div>

<!-- #include file="layouts/footer.asp" -->