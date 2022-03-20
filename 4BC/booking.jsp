<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Booking</title>

        <style>
            table, th, td {
                border: 1px solid black;
            }
            table {
                width: 100%;
            }

            .btn1{
                width: 100%;
            }
        </style>

        <script>
            function Prenota() {
                console.log("prenotazione effettuata"); // debug
            }

        </script>
    </head>
    
    <body>
        <h1>Booking</h1>
        <p>Visualizzazione tabella con i Parrucchieri disponibili, con possibilita' di scegliere quale andare a prenotare.</p>
        
        <%
        String usr = (String) request.getSession().getAttribute("username");
        if(usr == null){
            response.sendRedirect("index.html");
        }

        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";

        String controlloOrario = "false";
        int idProp = 0;

        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            if(request.getParameter("controlloOrario") != null){
                controlloOrario = request.getParameter("controlloOrario");
            }


            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            String query = "SELECT * FROM Proprietari"; 
            
            Statement st = connection.createStatement();
            ResultSet result = st.executeQuery(query);

            
            if(controlloOrario.equals("false")){
                out.println("<table>");

                    out.println("<tr>");
                        out.println("<th>Nome Locale</th>");
                        out.println("<th>Luogo</th>");
                        out.println("<th>Telefono</th>");
                        out.println("<th>Email</th>");
                        out.println("<th>Prenotazione</th>");
                    out.println("</tr>");
                    
                    while(result.next()){
                        String luogo = result.getString(5) + " " +result.getString(6) + "/" + result.getString(7);
                        idProp = Integer.parseInt(result.getString(8));          
                        out.println("<tr>");
                            out.println("<td>"+result.getString(4)+ "</td>");
                            out.println("<td>"+luogo+ "</td>");
                            out.println("<td>"+result.getString(9)+ "</td>");
                            out.println("<td>"+result.getString(3)+ "</td>");
                            
                            out.println("<td> <a href = 'booking.jsp?controlloOrario=true&idProprietario="+idProp+"'><button class = 'btn1'>Vedi Orario</button></a></td>");
                            out.println("</tr>");
                    }
                out.println("</table>");
            }else{
                result.next();
                idProp = Integer.parseInt(request.getParameter("idProprietario"));

                String querySelectProp = "SELECT * FROM Proprietari WHERE ID = '"+idProp+"'";
                String queryOrari = "SELECT orarioMattina,orarioPomeriggio FROM Orari WHERE codiceProprietario = '"+idProp+"';";
                String queryOrari2 = "SELECT * FROM Orari WHERE codiceProprietario = '"+idProp+"';";

                ResultSet r = st.executeQuery(querySelectProp);  
                ResultSet r1 = st.executeQuery(queryOrari); 
                ResultSet r2 = st.executeQuery(queryOrari2);

                
                out.println("<table>");

                    out.println("<tr>");
                        out.println("<th>Nome Locale</th>");
                        out.println("<th>Luogo</th>");
                        out.println("<th>Telefono</th>");
                        out.println("<th>Email</th>");
                        out.println("<th>Orari Disponibili</th>");
                        out.println("<th><button class = 'btn1'>Prenota</button></th>");
                        
                    out.println("</tr>");
                    
                    while(r.next() && r1.next()){
                        String luogo = r.getString(5) + " " +r.getString(6) + "/" + r.getString(7);        
                        
                        String oMattino = r1.getString(1); 
                        String oPomeriggio = r1.getString(2); 

                        String[] orarioM = oMattino.split("-");
                        double oraM1 = Double.parseDouble(orarioM[0]);
                        double oraM2 = Double.parseDouble(orarioM[1]);

                        //System.out.println("prima parte orario mattina: " + oraM1);  //debug
                        //System.out.println("seconda parte orario mattina: " + oraM2); //debug

                        String[] orarioP = oPomeriggio.split("-");
                        double oraP1 = Double.parseDouble(orarioP[0]);
                        double oraP2 = Double.parseDouble(orarioP[1]);
                        
                        int i = 0;
                        int j = 0;

                        out.println("<tr>");
                            out.println("<td>"+r.getString(4)+ "</td>");
                            out.println("<td>"+luogo+ "</td>");
                            out.println("<td>"+r.getString(9)+ "</td>");
                            out.println("<td>"+r.getString(3)+ "</td>");
                            
                            out.println("<td>");
                                out.println("<table>");
                                    out.println("<th>Giorno</th>");
                                    out.println("<th>Ora</th>");
                                    
                                    while(r2.next()){
                                        out.println("<tr>");
                                            out.println("<td>"+r2.getString("giorno")+ "</td>");
                                            /*String queryProva = "SELECT orarioMattina, orarioPomeriggio FROM Orario WHERE codiceProprietario = '"+idProp+"' AND giorno = '"+r2.getString("giorno")+"';";
                                            ResultSet r3 = st.executeQuery("queryProva");
                                            r3.next();

                                            String oMattino = r1.getString("orarioMattina"); 
                                            String oPomeriggio = r1.getString("orarioPomeriggio"); 
                                            
                                            String[] orarioM = oMattino.split("-");
                                            double oraM1 = Double.parseDouble(orarioM[0]);
                                            double oraM2 = Double.parseDouble(orarioM[1]);

                                            String[] orarioP = oPomeriggio.split("-");
                                            double oraP1 = Double.parseDouble(orarioP[0]);
                                            double oraP2 = Double.parseDouble(orarioP[1]);
                                            */
                                            out.println("<td>");
                                                out.println("<select name = 'orario' id='orario'>");
                                                    while(oraM1 < oraM2 ){    
                                                    i++;
                                                    j= i;
                                                    out.println("<option value = 'ora"+i+"'>"+oraM1+"</option>");
                                                    oraM1++;
                                                    }
                                                    while(oraP1 < oraP2){       
                                                        j++;
                                                        out.println("<option value = 'ora"+j+"'>"+oraP1+"</option>");
                                                        oraP1++;
                                                    }
                                                out.println("</select>");
                                            out.println("</td>");
                                        out.println("</tr>");
                                    }
                                out.println("</table>");
                            out.println("</td>");
                            
                        out.println("</tr>");
                    }
                out.println("</table>");
                
                out.println("<br><a href = 'booking.jsp?controlloOrario=false'><button class ='btn2'> Indietro </button></a>");
            }
        }
        catch(Exception e){
            out.println(e);
        }


        finally{
            if(connection != null){
                try{
                    connection.close();
                }
                catch(Exception e){out.println("Errore nella chiusura della connessione");}
            }
        }
        %>

        <br>
        <a href = "loginCliente.jsp"> 
            <br><input type="button" value="Home Cliente"/> <br> 
        </a>

    </body>

</html>