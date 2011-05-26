import com.cds.jira._
import java.net.URL
import java.util.ArrayList
import javax.naming.{Context, NamingException, InitialContext}
import javax.servlet.{ServletException, ServletConfig}
import org.apache.log4j.Logger
import javax.servlet.http.{HttpServletResponse, HttpServletRequest, HttpServlet}

/**
 * Updates data from Jira
 * @author rahul
 */
object SPServlet {
  val STORIES_PER_PAGE = 5
}

class SPServlet extends HttpServlet {
  val logger = Logger.getLogger(classOf[SPServlet])

  var soapUrl: String = null
  var username: String = null
  var password: String = null

  override def init(config: ServletConfig) {
    super.init(config)

    try {
      // Obtain our environment naming context
      val initCtx = new InitialContext();
      val envCtx = initCtx.lookup("java:comp/env").asInstanceOf[Context] ;

      // Look up the forwardUrl
      soapUrl = envCtx.lookup("jira/soapUrl").asInstanceOf[String];
      username = envCtx.lookup("jira/username").asInstanceOf[String];
      password = envCtx.lookup("jira/password").asInstanceOf[String];
    } catch {
      case e: NamingException =>
      logger.error("Init failed", e);
      throw new ServletException("Could not initialize servlet", e);
    }

  }


  override def doGet(req: HttpServletRequest, resp: HttpServletResponse) = {

    logger.debug("Request received: " + req.getParameterMap())

    val myService = new JiraSoapServiceServiceLocator()
    val ss = myService.getJirasoapserviceV2(new URL(soapUrl))
    val token = getToken(req, ss)

    req.getParameter("f") match {
      case "v" => {
        val versions: Array[RemoteVersion] = ss.getVersions(token, req.getParameter("p"))
        logger.debug("Retrieved versions : " + versions.length)
        req.setAttribute("versions", versions.filter(v => !v.isArchived()))
        getServletContext.getRequestDispatcher("/versions.json.jsp").forward(req, resp)
      }
      case "s" => {
        val statuses = ss.getStatuses(token)
        val statusMap = Map.empty[String, String] ++ statuses.map(s => (s.getId, s.getName))
        logger.debug("Status Map: " + statusMap)

        val projectCode = req.getParameter("p")
        val versionId = req.getParameter("v")
        val batch = Integer.parseInt(req.getParameter("b"))
        val project = ss.getProjectByKey(token, projectCode)
        val versions = ss.getVersions(token, projectCode)
        val myVersions = versions.filter(v => v.getId() == versionId)
        if (myVersions.length == 0) {
          resp.getWriter.println("")
        } else {
          val jql = "project=\"" + project.getName() + "\" and fixVersion=\"" +
              myVersions(0).getName() + "\" and type in (\"Story\",\"Epic\",\"Bug\",\"Improvement\") order by key"
          logger.debug("jql: " + jql)
          val stories: Array[RemoteIssue] = ss.getIssuesFromJqlSearch(token, jql, 100)
          logger.debug("Retrieved stories : " + stories.length)


          var newLen = SPServlet.STORIES_PER_PAGE;
          if (stories.length - (batch * SPServlet.STORIES_PER_PAGE) < 0) {
            newLen = stories.length % SPServlet.STORIES_PER_PAGE
          }
          val myStories = new Array[RemoteIssue](newLen);
          Array.copy(stories, (batch - 1) * SPServlet.STORIES_PER_PAGE, myStories, 0, newLen)
          val tickets = myStories.map(story => "\"" + story.getKey + "\"").mkString(",")
          logger.debug("Tickets: " + tickets)

          val allTasks = new ArrayList[Tasks]()
          myStories.foreach(story => {
            story.setStatus(statusMap(story.getStatus))
            val jql2 = "parent =\"" + story.getKey + "\" and type=\"Technical Task\" order by key"
            logger.debug("jql2: " + jql2)
            val tasks: Array[RemoteIssue] = ss.getIssuesFromJqlSearch(token, jql2, 200)
            tasks.foreach(task => {
              allTasks.add(new Tasks(task.getKey, story.getKey, statusMap(task.getStatus)))
            })
            logger.debug("Retrieved tasks for " + story.getKey + ": " + tasks.length)

          })

          logger.debug("All Tasks: " + allTasks)
          myStories.foreach(s => s.setEnvironment("code" + ((s.getAssignee.hashCode % 16 + 16) % 16)))
          req.setAttribute("stories", myStories)
          req.setAttribute("tasks", allTasks)
          getServletContext.getRequestDispatcher("/stories.jsp").forward(req, resp)

        }

      }
      case "p" | null => {
        val projects: Array[RemoteProject] = ss.getProjectsNoSchemes(token)
        logger.debug("Retrieved projects : " + projects.length)
        req.setAttribute("projects", projects)
        getServletContext.getRequestDispatcher("/home.jsp").forward(req, resp)
      }
    }

  }


  override def doPost(req: HttpServletRequest, resp: HttpServletResponse) = doGet(req, resp)

  private def getToken(req: HttpServletRequest, ss: JiraSoapService): String = {

    if (req.getSession(true).getAttribute("token") == null) {
      logger.debug("Creating token")
      val token = ss.login(username, password)
      req.getSession().setAttribute("token", token)
      logger.debug("Token created: " + token)
      token
    } else {
      val token = req.getSession().getAttribute("token").asInstanceOf[String]
      logger.debug("Using token from session: " + token)
      token
    }

  }
}