using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoFinal_IngSoftware
{
    public partial class Menu : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            Classes.SystemUser objsystemuser = new Classes.SystemUser();


            lblRol.Text = "Bienvenido a".ToString();
            

        }

        

        protected void btnLogOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("LogIn.aspx");
        }





    }
}