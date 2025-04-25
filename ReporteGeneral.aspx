<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="ReporteGeneral.aspx.cs" Inherits="ProyectoFinal_IngSoftware.ReporteGeneral" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container text-center"> 
           
       <h1 class="display-3"></h1>
           <h1 class="display-3"> SCRUM Board </h1>
           <div runat="server" id="myDiv"></div>
       

        <div class="d-flex justify-content-center">
            <div id="backlogClm" runat="server" ClientIDMode="Static" class="card column">  
              <h5 id="backlogH5" class="card-header center">Backlog</h5>              
 
            </div>
 
            <div id="toDoClm" runat="server" ClientIDMode="Static" class="card column">
              <h5 class="card-header center">To Do</h5>              
 
            </div>
 
            <div id="wipClm" runat="server" ClientIDMode="Static" class="card column">
              <h5 class="card-header center">Work In Progress</h5>              
 
            </div>

            <div id="doneClm" runat="server" ClientIDMode="Static" class="card column">
              <h5 class="card-header center">Done</h5>
            </div>

        </div>

            <p>  
                &nbsp;</p>

                 

                <!-- Modal -->
        

        <!--
        <Button ID="btnConsultar" class="btn btn-outline-dark" runat="server" Text="Consultar" OnClick="btnConsultar_Click" />       
        <Button ID="btnLimpiar" class="btn btn-outline-dark" runat="server" Text="Limpiar" OnClick="btnLimpiar_Click" />
            -->
             <!--
        <button type="button" class="btn btn-outline-dark" data-toggle="modal" data-target="#exampleModal" Text="Agregar" />  
        <button id="btnGuardar" class="btn btn-outline-dark" data-toggle="modal" data-target="#confirmacionModal" Text="Guardar" />-->
        <button type="button" class="btn btn-outline-dark" data-toggle="modal" data-target="#agregarModal">Agregar User Story</button>
        <!--<button type="button" class="btn btn-outline-dark" data-toggle="modal" data-target="#confirmacionModal">Guardar</button>-->
        <asp:button id="btnGuardar" class="btn btn-outline-dark" runat="server" Text="Guardar" OnClientClick="sendChanges();return false"/>
        <asp:Button id="btnRefrescar" class="btn btn-outline-dark" runat="server" Text="Refrescar" OnClick="btnRefrescar_Click"/>
        

         <!-- Modal Guardar -->
        <div class="modal fade" id="confirmacionModal" tabindex="-1" role="dialog" aria-labelledby="confirmacionModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="confirmacionModalLabel">¡Completado!</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                Los datos han sido guardados exitosamente.
              </div>
              <div class="modal-footer">                
                <button type="button" class="btn btn-primary" data-dismiss="modal">Cerrar</button>
              </div>
            </div>
          </div>
        </div>   
        <!-- Modal agregar nuevo US titulo, descripcion, prioridad, estado default backlog-->
        <div class="modal fade" id="agregarModal" tabindex="-1" role="dialog" aria-labelledby="agregarModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="agregarModalLabel">Nuevo User Story</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <form>
                  <div class="form-group">
                    <label for="txtTitulo" class="col-form-label">Titulo:</label>
                    <asp:TextBox id="txtTitulo" class="form-control" placeholder="Nuevo titulo" runat="server"></asp:TextBox>                    
                  </div>
                  <div class="form-group">
                      <label for="txtDescripcion" class="col-form-label">Descripción:</label>
                      <asp:TextBox id="txtDescripcion" class="form-control" placeholder="Descripcion" runat="server"></asp:TextBox>
                  </div>
                  <div class="form-group">
                      <label for="ddlPrioridad" class="col-form-label">Prioridad:</label>
                       <asp:DropDownList ID="ddlPrioridad"  class="round form-control" runat="server" OnSelectedIndexChanged="Page_Load"></asp:DropDownList>                      
                  </div>  
                </form>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-outline-dark" data-dismiss="modal">Cerrar</button>                
                <asp:Button id="btnNuevo" class="btn btn-primary" runat="server" Text="Agregar" OnClick="btnNuevo_Click"/>
              </div>
            </div>
          </div>
        </div>  

</asp:Content>

