<!-- #include file="connect.asp" -->
<!-- #include file="layouts/header.asp" -->
<!-- #include file="sidebar.asp" -->

    <div class="container-fluid">
        <div class="d-flex bd-highlight mb-3">
            <div class="me-auto p-2 bd-highlight"><h2>Danh sách nhân viên</h2></div>
            <div class="p-2 bd-highlight">
                <a href="/AddEmployee.asp" class="btn btn-primary">Thêm nhân viên</a>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table dark">
                <thead>
                    <tr>
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
                            Set cmdPrep = Server.CreateObject("ADODB.Command")
                            connDB.Open()
                            cmdPrep.ActiveConnection = connDB
                            cmdPrep.CommandType = 1
                            cmdPrep.Prepared = True
                            cmdPrep.CommandText = "SELECT MaNV, TenNV, Email, SDT, DiaChi, GioiTinh, CCCD, NgaySinh FROM NHANVIEN"
                            ' cmdPrep.parameters.Append cmdPrep.createParameter("offset",3,1, ,offset)
                            ' cmdPrep.parameters.Append cmdPrep.createParameter("limit",3,1, , limit)


                            Set Result = cmdPrep.execute
                            do while not Result.EOF
                    %>

                        <tr>
                            <td><%=Result("MaNV")%></td>
                            <td><%=Result("TenNV")%></td>
                            <td><%=Result("Email")%></td>
                            <td><%=Result("SDT")%></td>
                            <td><%=Result("DiaChi")%></td>
                            <td><%=Result("GioiTinh")%></td>
                            <td><%=Result("CCCD")%></td>
                            <td><%=Result("NgaySinh")%></td>
                            <td>
                                <a href="" class="btn btn-secondary"><i class="fa-solid fa-pen-to-square"></i></a>
                                <a data-href="" class="btn btn-danger"title="Delete"><i class="fa-solid fa-trash"></i></a>
                            </td>
                        </tr>

                    <%
                        Result.MoveNext
                        loop
                    %>
                </tbody>
            </table>
        </div>
    </div>

<!-- #include file="layouts/footer.asp" -->