using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using ProyectoFinal_IngSoftware.Classes;
using System.Diagnostics;
using System.Web.Services;
using static System.Net.Mime.MediaTypeNames;
using System.Text.RegularExpressions;
using Newtonsoft.Json;


namespace ProyectoFinal_IngSoftware
{
    public partial class ReporteGeneral : System.Web.UI.Page
    {
        private List<UserStory> stories = new List<UserStory>();
        
        

        protected void Page_Load(object sender, EventArgs e)
        {
                        
            if (!IsPostBack)
            {
                
                LlenarListaStories();
                llenarColumnas();
                llenarDropdownAgregar();
                //myDiv.InnerHtml = " " + var;
                //myDiv.InnerHtml = " " + stories.ToString();
                //LlenarGridBL();
                //LlenarDropdown();
            }
        }

        private void llenarColumnas()
        {
            /*
            <div id="" class="card portlet" style="width: 15rem;">
                <div class="card-body">
                  <h5 class="card-title portlet-header">User Story 1</h5>
                  <h6 class="card-subtitle mb-2 text-muted">Priority</h6>
                  <textarea class="form-control" id="cardTxtArea" rows="3">Some quick example text to build on the card title and make up the bulk of the card's content.</textarea>     
                </div>
              </div>*/

            //myDiv.InnerHtml = myDiv.InnerHtml + us.Nombre;



            foreach (UserStory us in stories)
            {                

                switch (us.Estado.ToUpper())
                {
                    case "BACKLOG":
                        crearUSCard(backlogClm, us);
                        break;
                    case "TODO":
                        crearUSCard(toDoClm, us);
                        break;
                    case "WIP":
                        crearUSCard(wipClm, us);
                        break;
                    case "DONE":
                        crearUSCard(doneClm, us);
                        break;

                }
                
            }
        }
        private void llenarDropdownAgregar()
        {
                    
            for (int i = 1; i < 6; i++)
            {
                ddlPrioridad.Items.Add(i.ToString());
            }

        }

        protected void btnNuevo_Click(object sender, EventArgs e)
        {
            int resultado = UserStory.Agregar(txtTitulo.Text, txtDescripcion.Text, int.Parse(ddlPrioridad.Text), "BACKLOG");

            if (resultado > 0)            {

                txtTitulo.Text = string.Empty;
                txtDescripcion.Text = string.Empty;
                ddlPrioridad.SelectedIndex = 0;
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            else
            {
                

            }
        }

        protected void btnRefrescar_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ReporteGeneral.aspx");
        }

        
        private static bool checkDiferencias(List<string> ids, string columnName)
        {

            foreach (var item in ids)
            {
                if (!item.Contains(columnName))
                {
                    return true;
                }
            }

            return false;           

        }

        private static bool algunCambio(List<string> backlogIds, List<string> todoIds, List<string> wipIds, List<string> doneIds)
        {
            if(checkDiferencias(backlogIds, "BACKLOG"))
            {
                return true;
            }else if(checkDiferencias(todoIds, "TODO"))
            {
                return true;
            }else if(checkDiferencias(wipIds, "WIP"))
            {
                return true;
            }else if(checkDiferencias(doneIds, "DONE"))
            {
                return true;
            }

            return false;
        }

        private static List<UserStory> ObtenerUSActualizar(List<string> ids, string columnName)
        {
            List<UserStory> usActualizar = new List<UserStory>();

            foreach (var item in ids)
            {
                if (!item.Contains(columnName))                {
                    UserStory paraActualizar = new UserStory();
                    paraActualizar.USId = Int32.Parse(mantenerNumeros(item));
                    paraActualizar.Estado = columnName;
                    usActualizar.Add(paraActualizar);
                }
            }

            return usActualizar;
        }
        /*
        private static List<UserStory> ObtenerListaUSActualizar(List<UserStory> backlogStories, List<UserStory> todoStories, List<UserStory> wipStories, List<UserStory> doneStories)
        {
            List<UserStory> allUSActualizar = new List<UserStory>();

            allUSActualizar.AddRange(backlogStories);
            allUSActualizar.AddRange(todoStories);
            allUSActualizar.AddRange(wipStories);
            allUSActualizar.AddRange(doneStories);

            return allUSActualizar;
        }
        */
        private static List<UserStory> ObtenerListaUSActualizar(List<string> backlogStories, List<string> todoStories, List<string> wipStories, List<string> doneStories)
        {
            List<UserStory> allUSActualizar = new List<UserStory>();

            allUSActualizar.AddRange(ObtenerUSActualizar(backlogStories, "BACKLOG"));
            allUSActualizar.AddRange(ObtenerUSActualizar(todoStories, "TODO"));
            allUSActualizar.AddRange(ObtenerUSActualizar(wipStories, "WIP"));
            allUSActualizar.AddRange(ObtenerUSActualizar(doneStories, "DONE"));

            return allUSActualizar;
        }

        private static void ActualizarUserStories(List<UserStory> allUSActualizar)
        {
            foreach (UserStory usActualizar in allUSActualizar)
            {
                Debug.WriteLine(ModificarEstadoID(usActualizar.USId, usActualizar.Estado));
            }
        }

        public static string mantenerNumeros(string text)
        {
            if (string.IsNullOrEmpty(text))
            {
                return text;
            }

            return Regex.Replace(text, @"\D", "");
        }

        public static string mantenerLetras(string text)
        {
            if (string.IsNullOrEmpty(text))
            {
                return text;
            }

            return Regex.Replace(text, @"\d", "");
        }

        public static List<string> splitPorComas(string text)
        {
            if (string.IsNullOrEmpty(text))
            {
                return new List<string>();
            }

            return text.Trim().Split(',').ToList();
        }

        public static List<UserStory> ExtraerValoresJSON(string jsonString)
        {
            var data = JsonConvert.DeserializeObject<Dictionary<string, List<string>>>(jsonString);
            
            List<UserStory> listaStories = new List<UserStory>();

            foreach (var entry in data)
            {
                string key = entry.Key;
                List<string> values = entry.Value;

                // Assuming there are at least 3 values (Name, Priority, Description)
                if (values.Count >= 3)
                {
                    UserStory paraActualizar = new UserStory();
                    paraActualizar.USId = Int32.Parse(mantenerNumeros(key));
                    paraActualizar.Nombre = values[0].Trim();
                    paraActualizar.Prioridad = Int32.Parse(values[1].Trim());
                    paraActualizar.Descripcion = values[2].Trim();
                    paraActualizar.Estado = mantenerLetras(key);

                    listaStories.Add(paraActualizar);                    

                }                
                
            }

            return listaStories;
        }

        
        //Funcion que obtiene respuesta de AJAX
        [WebMethod()]
        public static void MyWebMethod(string backlogInfo, string todoInfo, string wipInfo, string doneInfo)
        {
            /*
            Debug.Print("BacklogInfo = " + backlogInfo + "\nToDoInfo = " + todoInfo + "\nWIPInfo = " + wipInfo + "\nDoneInfo = " + doneInfo);
            List<UserStory> listaStoriesBacklog = ExtraerValoresJSON(backlogInfo);
            List<UserStory> listaStoriesToDo = ExtraerValoresJSON(todoInfo);
            List<UserStory> listaStoriesWIP = ExtraerValoresJSON(wipInfo);
            List<UserStory> listaStoriesDone = ExtraerValoresJSON(doneInfo);
            */
            //Debug.Print("Result = " + listaStoriesBacklog.First().USId + " " + listaStoriesBacklog.First().Nombre + " " + listaStoriesBacklog.First().Descripcion);


            //ActualizarUserStories(ObtenerListaUSActualizar(listaStoriesBacklog, listaStoriesToDo, listaStoriesWIP, listaStoriesDone));


            
            List<string> backlogStories = splitPorComas(backlogInfo);
            List<string> toDoStories = splitPorComas(todoInfo);
            List<string> wipStories = splitPorComas(wipInfo);
            List<string> doneStories = splitPorComas(doneInfo);

            

            if(algunCambio(backlogStories, toDoStories, wipStories, doneStories))
            {
                ActualizarUserStories(ObtenerListaUSActualizar(backlogStories, toDoStories, wipStories, doneStories));
                Debug.Print("Cambios guardados en la Base de Datos");
            }
            else
            {
                Debug.Print("No hubo cambios");
            }

            int blog = backlogStories.Count();
            int todo = toDoStories.Count();
            int wip = wipStories.Count();
            int done = doneStories.Count();

            Debug.Print("BacklogInfo = " + blog + "\nToDoInfo = " + todo + "\nWIPInfo = " + wip + "\nDoneInfo = " + done);           
            
        }
        

        /*
        [WebMethod()]
        public static void MyWebMethod(string allInfo)
        {
            

            Debug.Print("BacklogInfo = " + allInfo.ToString());

            /*
            List<string> backlogStories = splitPorComas(backlogInfo);
            List<string> toDoStories = splitPorComas(todoInfo);
            List<string> wipStories = splitPorComas(wipInfo);
            List<string> doneStories = splitPorComas(doneInfo);



            if (algunCambio(backlogStories, toDoStories, wipStories, doneStories))
            {
                ActualizarUserStories(ObtenerListaUSActualizar(backlogStories, toDoStories, wipStories, doneStories));
                Debug.Print("Cambios guardados en la Base de Datos");
            }
            else
            {
                Debug.Print("No hubo cambios");
            }

            int blog = backlogStories.Count();
            int todo = toDoStories.Count();
            int wip = wipStories.Count();
            int done = doneStories.Count();

            Debug.Print("BacklogInfo = " + blog + "\nToDoInfo = " + todo + "\nWIPInfo = " + wip + "\nDoneInfo = " + done);
            
        }
        */

        public static int ModificarEstadoID(int userstoryid, string estado)
        {
            int retorno = 0;

            SqlConnection Conn = new SqlConnection();
            try
            {
                using (Conn = DBConn.obtenerConexion())
                {
                    SqlCommand cmd = new SqlCommand("ACTUALIZAR_USERSTORYESTADOID", Conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.Add(new SqlParameter("@USID", userstoryid));
                    cmd.Parameters.Add(new SqlParameter("@ESTADO", estado));                    

                    retorno = cmd.ExecuteNonQuery();
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                retorno = -1;
            }
            finally
            {
                Conn.Close();
            }

            return retorno;
        }

        public static int ModificarUS(UserStory paraActualizar)
        {
            int retorno = 0;

            SqlConnection Conn = new SqlConnection();
            try
            {
                using (Conn = DBConn.obtenerConexion())
                {
                    SqlCommand cmd = new SqlCommand("ACTUALIZAR_USERSTORYID", Conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    Debug.WriteLine(paraActualizar.Nombre);
                    Debug.WriteLine(paraActualizar.Descripcion);
                    Debug.WriteLine(paraActualizar.Prioridad);
                    Debug.WriteLine(paraActualizar.Estado);
                    Debug.WriteLine(paraActualizar.USId);

                    cmd.Parameters.Add(new SqlParameter("@NOMBRE", paraActualizar.Nombre));
                    cmd.Parameters.Add(new SqlParameter("@DESCRIPCION", paraActualizar.Descripcion));
                    cmd.Parameters.Add(new SqlParameter("@PRIORIDAD", paraActualizar.Prioridad));
                    cmd.Parameters.Add(new SqlParameter("@ESTADO", paraActualizar.Estado));
                    cmd.Parameters.Add(new SqlParameter("@USID", paraActualizar.USId));

                    retorno = cmd.ExecuteNonQuery();
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                retorno = -1;
            }
            finally
            {
                Conn.Close();
            }

            return retorno;
        }

        //Funcion para crear cada US Card
        private void crearUSCard(HtmlGenericControl clm, UserStory us)
        {
            clm.InnerHtml = clm.InnerHtml + "<div id=\"" + us.Estado.ToUpper() + us.USId + "\" class=\"card portlet\" style=\"width: 15rem;\"><div class=\"card-body\"><h5 class=\"card-title portlet-header\">" + us.USId + "</h5>";
            clm.InnerHtml = clm.InnerHtml + "<h6 class=\"card-subtitle mb-2 text-muted\">Nombre: </h6>";
            clm.InnerHtml = clm.InnerHtml + "<textarea class=\"card-text form-control\" id=\"cardTxtANombre" + us.USId + "\" rows=\"1\"> " + us.Nombre + "</textarea></br>";
            clm.InnerHtml = clm.InnerHtml + "<h6 class=\"card-subtitle mb-2 text-muted\">Prioridad: </h6>";
            clm.InnerHtml = clm.InnerHtml + "<textarea class=\"card-text form-control\" id=\"cardTxtAPrior" + us.USId + "\" rows=\"1\"> " + us.Prioridad + "</textarea></br>";
            clm.InnerHtml = clm.InnerHtml + "<h6 class=\"card-subtitle mb-2 text-muted\">Descripcion: </h6>";
            clm.InnerHtml = clm.InnerHtml + "<textarea class=\"card-text form-control\" id=\"cardTxtADesc" + us.USId + "\" rows=\"3\">" + us.Descripcion + "</textarea>";
            clm.InnerHtml = clm.InnerHtml + "</div></div > ";
        }

        //<asp:TextBox id = "txtTitulo" class="form-control" placeholder="Nuevo titulo" runat="server"></asp:TextBox> 

        protected int LlenarListaStories()
        {
            int retorno = 0;
            
            SqlConnection Conn = new SqlConnection();
            try
            {
                using (Conn = DBConn.obtenerConexion())
                {
                    using (SqlCommand cmd = new SqlCommand("CONSULTAR_US", Conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    })
                    {                        

                        using (var reader = cmd.ExecuteReader())
                        {
                            stories.Clear();
                            while (reader.Read())
                            {
                                //stories.Add(new UserStory { USId = reader.GetInt32(0), Nombre = reader.GetString(1), Descripcion = reader.GetString(2), Prioridad = reader.GetInt32(3), Estado = reader.GetString(4) });
                                stories.Add(new UserStory() { USId = reader.GetInt32(0), Nombre = reader.GetString(1), Descripcion = reader.GetString(2), Prioridad = reader.GetInt32(3), Estado = reader.GetString(4) });
                                
                            }
                                                            
                        }

                        /*
                        using (SqlDataAdapter SDA = new SqlDataAdapter())
                        {
                            SDA.SelectCommand = cmd;
                            using (DataTable dt = new DataTable())
                            {
                                SDA.Fill(dt);
                                gv.DataSource = dt;
                                gv.DataBind();

                                retorno = cmd.ExecuteNonQuery();
                            }
                        }*/

                    }
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                retorno = -1;
            }
            finally
            {
                Conn.Close();
            }

            return retorno;
        }


        /*
        protected void LlenarGridBL()
        {
            string constr = ConfigurationManager.ConnectionStrings["Conexion"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("ReporteGeneral"))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gvBacklog.DataSource = dt;
                            gvBacklog.DataBind();
                        }
                    }
                }
            }
        }
        protected void LlenarGridToDo()
        {
            string constr = ConfigurationManager.ConnectionStrings["Conexion"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("ReporteGeneral"))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gvToDo.DataSource = dt;
                            gvToDo.DataBind();
                        }
                    }
                }
            }
        }
        protected void LlenarGridWIP()
        {
            string constr = ConfigurationManager.ConnectionStrings["Conexion"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("ReporteGeneral"))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gvWIP.DataSource = dt;
                            gvWIP.DataBind();
                        }
                    }
                }
            }
        }


        protected void LlenarGridDone()
        {
            string constr = ConfigurationManager.ConnectionStrings["Conexion"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("ReporteGeneral"))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            gvDone.DataSource = dt;
                            gvDone.DataBind();
                        }
                    }
                }
            }
        }
        protected void LlenarDropdown()
        {
            string constr = ConfigurationManager.ConnectionStrings["Conexion"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("CONSULTAR_TECNICOS"))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);
                            ddlTecnicos.DataSource = dt;

                            ddlTecnicos.DataTextField = dt.Columns["Tecnico"].ToString();
                            ddlTecnicos.DataValueField = dt.Columns["TecnicoID"].ToString();
                            ddlTecnicos.DataBind();
                        }
                    }
                }
            }
        }

        

        protected void btnConsultar_Click(object sender, EventArgs e)
        {
            int codigo = int.Parse(ddlTecnicos.SelectedValue);

            
            string constr = ConfigurationManager.ConnectionStrings["Conexion"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("ReporteGeneral_Filtro @CODIGO =" + codigo))


                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = con;
                    sda.SelectCommand = cmd;
                    using (DataTable dt = new DataTable())
                    {
                        sda.Fill(dt);
                        //gvReporte.DataSource = dt;
                        //gvReporte.DataBind();  // actualizar el grid view
                    }
                }
            }
        }

       protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            //LlenarGrid();
        }

        */
    }

}