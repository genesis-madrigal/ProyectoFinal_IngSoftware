<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="SystemUsers.aspx.cs" Inherits="ProyectoFinal_IngSoftware.SystemUsers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container text-center">
    <h1 class="display-3"> Usuarios del Sistema </h1>
    <p> &nbsp;</p>
    <p> &nbsp;</p>

<div class="d-flex justify-content-center">
    <asp:GridView ID="gvSystemUsers" runat="server" AutoGenerateColumns="False" CssClass="mydatagrid" PagerStyle-CssClass="pager" HeaderStyle-CssClass="header" RowStyle-CssClass="rows" AllowPaging="True">
        
        <Columns>
                    <asp:BoundField DataField="LogInUser" HeaderText="Nombre de Usuario" SortExpression="LogInUser" />
                    <asp:BoundField DataField="Clave" HeaderText="Clave" SortExpression="Clave" />
          </Columns>
    </asp:GridView>
</div>

        <p>
            &nbsp;</p>
        <p>
         <asp:Label ID="lblLogInUser" class="lead" runat="server" Text="Log In:"></asp:Label>
        </p> 
        <asp:TextBox ID="txtLogInUser"  class="round form-control" runat="server"></asp:TextBox>
          <p>
         <asp:Label ID="lblClave" class="lead" runat="server" Text="Clave:"></asp:Label>
        </p> 
        <asp:TextBox ID="txtClave"  class="round form-control" runat="server"></asp:TextBox>
        <br />
        <asp:Button ID="btnAgregar" class="btn btn-outline-dark" runat="server" Text="Agregar" OnClick="btnAgregar_Click" />
        <asp:Button ID="btnConsultar" class="btn btn-outline-dark" runat="server" Text="Consultar" OnClick="btnConsultar_Click" />
        <asp:Button ID="btnModificar" class="btn btn-outline-dark" runat="server" Text="Modificar" OnClick="btnModificar_Click" />
        <asp:Button ID="btnEliminar" class="btn btn-outline-dark" runat="server" Text="Eliminar" OnClick="btnEliminar_Click" />

</asp:Content>
