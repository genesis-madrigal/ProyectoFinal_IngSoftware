using ProyectoFinal_IngSoftware.Classes;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoFinal_IngSoftware
{
    public partial class SystemUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)

        {
            if (!IsPostBack)
            {
                LlenarGrid();

            }
        }

        protected void LlenarGrid()
        {
            string constr = ConfigurationManager.ConnectionStrings["Conexion"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT *  FROM SystemUsers"))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gvSystemUsers.DataSource = dt;
                            gvSystemUsers.DataBind();
                        }
                    }
                }
            }
        }

        public void alertas(String texto)
        {
            string message = texto;
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("<script type = 'text/javascript'>");
            sb.Append("window.onload=function(){");
            sb.Append("alert('");
            sb.Append(message);
            sb.Append("')};");
            sb.Append("</script>");
            ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", sb.ToString());

        }


        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            int resultado = SystemUser.Agregar(txtLogInUser.Text, txtClave.Text);

            if (resultado > 0)
            {
                alertas("Usuario del sistema ha sido ingresado con éxito");
                txtLogInUser.Text = string.Empty;
                txtClave.Text = string.Empty;
                LlenarGrid();
            }
            else
            {
                alertas("Error al ingresar usuario del sistema");

            }
        }

        protected void btnConsultar_Click(object sender, EventArgs e)
        {
            string codigo = txtLogInUser.Text;

            if (string.IsNullOrEmpty(codigo))
            {
                LlenarGrid();
            } else
            {
                string constr = ConfigurationManager.ConnectionStrings["Conexion"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constr))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT * FROM SystemUsers WHERE LogInUser ='" + codigo + "'"))


                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gvSystemUsers.DataSource = dt;
                            gvSystemUsers.DataBind();  // actualizar el grid view
                        }
                    }
                }
            }
            
        }


        protected void btnModificar_Click(object sender, EventArgs e)
        {

            int resultado = 0;

            //Para hacer check de si son numeros o no
            bool logInUser = string.IsNullOrEmpty(txtLogInUser.Text);
            bool clave = string.IsNullOrEmpty(txtClave.Text);

            if (!logInUser && !clave)
            {
                resultado = SystemUser.ModificarID(txtLogInUser.Text, txtClave.Text);
            }
            else
            {
                resultado = -2;
            }


            if (resultado > 0)
            {
                alertas("Usuario del sistema ha sido actualizado con éxito");
                txtLogInUser.Text = string.Empty;
                txtClave.Text = string.Empty;
                LlenarGrid();
            }
            else if (resultado == -2)
            {
                alertas("Error al actualizar el usuario del sistema: Ingrese un usuario o clave");
            }
            else
            {
                alertas("Error al actualizar el usuario del sistema");

            }
        }


        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            int resultado = SystemUser.Borrar(txtLogInUser.Text);

            if (resultado > 0)
            {
                alertas("Asignación ha sido eliminado con éxito");
                txtLogInUser.Text = string.Empty;
                txtClave.Text = string.Empty;
                LlenarGrid();
            }
            else
            {
                alertas("Error al eliminar el usuario del sistema");

            }
        }
    }
}