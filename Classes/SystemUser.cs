using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Security.Cryptography;
using System.Runtime.CompilerServices;

namespace ProyectoFinal_IngSoftware.Classes
{
    public class SystemUser
    {
        //atributos
        private static string LogInUser;
        private static string Clave;

        //constructor
        public SystemUser()
        {

        }

        //Getter = me devuelve un valor
        //Setter = asignar un valor a un atributo


        public string GetLogin()
        {
            return LogInUser;
        }

        public void SetLogin(string login)
        {
            LogInUser = login;
        }

        public void SetClave(string clave)
        {
            Clave = clave;
        }

  

        public static int ValidarLogin()
        {
            int retorno = 0;        
          
            SqlConnection Conn = new SqlConnection();
            try
            {
                using (Conn = DBConn.obtenerConexion())
                {
                    using (SqlCommand cmd = new SqlCommand("VALIDAR_USUARIO", Conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    })
                    {
                        cmd.Parameters.Add(new SqlParameter("@loginuser", LogInUser));
                        cmd.Parameters.Add(new SqlParameter("@clave", Clave));
                        using (SqlDataAdapter SDA = new SqlDataAdapter())
                        {
                            SDA.SelectCommand = cmd;
                            using (DataTable dt = new DataTable())
                            {
                                SDA.Fill(dt);
                                if(dt.Rows.Count < 1)
                                {
                                    retorno = -2;
                                }
                                else
                                {
                                    retorno = 1;
                                }

                                
                            }
                        }

                    }
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                retorno = -3;
            }
            finally
            {
                Conn.Close();
            }
          
            return retorno;
        }

       
        
        public static int Agregar(string loginuser, string clave)
        {
            int retorno = 0;

            SqlConnection Conn = new SqlConnection();
            try
            {
                using (Conn = DBConn.obtenerConexion())
                {
                    SqlCommand cmd = new SqlCommand("INSERTAR_SYSTEMUSERS", Conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.Add(new SqlParameter("@LOGINUSER", loginuser));
                    cmd.Parameters.Add(new SqlParameter("@CLAVE", clave));


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


        public static int Borrar(string loginuser)
        {
            int retorno = 0;

            SqlConnection Conn = new SqlConnection();
            try
            {
                using (Conn = DBConn.obtenerConexion())
                {
                    SqlCommand cmd = new SqlCommand("BORRAR_SYSTEMUSERS", Conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.Add(new SqlParameter("@LOGINUSER", loginuser));


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

        public static int ConsultarID(string loginuser, GridView gv)
        {
            int retorno = 0;
            SqlConnection Conn = new SqlConnection();
            try
            {
                using (Conn = DBConn.obtenerConexion())
                {
                    using (SqlCommand cmd = new SqlCommand("CONSULTAR_SYSTEMUSERS_ID", Conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    })
                    {
                        cmd.Parameters.Add(new SqlParameter("@LOGINUSER", loginuser));
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
                        }

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
        public static int ModificarID(string loginuser, string clave)
        {
            int retorno = 0;

            SqlConnection Conn = new SqlConnection();
            try
            {
                using (Conn = DBConn.obtenerConexion())
                {
                    SqlCommand cmd = new SqlCommand("ACTUALIZAR_SYSTEMUSERS", Conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.Add(new SqlParameter("@LOGINUSER", loginuser));
                    cmd.Parameters.Add(new SqlParameter("@CLAVE", clave));

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


    }
}