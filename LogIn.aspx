<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogIn.aspx.cs" Inherits="ProyectoFinal_IngSoftware.LogIn" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

	<title></title>

	<link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,900&display=swap" rel="stylesheet">

	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
	
	<link rel="stylesheet" href="css/style.css">



</head>
<body>
	<section class="ftco-section">
		<div class="container">
			<div class="row justify-content-center">
				<div class="col-md-6 text-center mb-5">
					<h2 class="heading-section">Interactive SCRUM Board</h2>
				</div>
			</div>
			<div class="row justify-content-center">
				<div class="col-md-12 col-lg-10">
					<div class="wrap d-md-flex">
						<div class="text-wrap p-4 p-lg-5 text-center d-flex align-items-center order-md-last">
							<div class="text w-100">
								<h2>Bienvenido al inicio de sesión</h2>
							</div>
			      </div>
						<div class="login-wrap p-4 p-lg-5">
			      	<div class="d-flex">
			      		<div class="w-100">
			      			<h3 class="mb-4">Iniciar Sesión</h3>
			      		</div>
								<div class="w-100">
									<p class="social-media d-flex justify-content-end">
									</p>
								</div>
			      	</div>
							<form id="form1" runat="server" action="#" class="signin-form">
			      		<div class="form-group mb-3">
			      			<label class="label" for="name">Usuario</label>
							<asp:TextBox ID="txtUsuario" class="form-control" placeholder="Usuario" runat="server"></asp:TextBox>
			      		</div>
		            <div class="form-group mb-3">
		            	<label class="label" for="password">Contraseña</label>
					<asp:TextBox type = "password" ID="txtClave" class="form-control" placeholder="Contraseña" runat="server"></asp:TextBox>
		            </div>
		            <div class="form-group">
						<asp:Button ID="btnIngresar" class="form-control btn btn-primary submit px-3" runat="server" Text="Ingresar" OnClick="btnIngresar_Click" />
		            </div>
		            <div class="form-group d-md-flex">
						
		            </div>
		          </form>
		        </div>
		      </div>
				</div>
			</div>
		</div>
	</section>

	<script src="js/jquery.min.js"></script>
  <script src="js/popper.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <script src="js/main.js"></script>
	
	</body>
</html>
