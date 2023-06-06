package kr.or.ddit;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.aspose.pdf.Document;
import com.aspose.pdf.TextAbsorber;

import kr.or.ddit.service.MemberService;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

/**
 * Handles requests for the application home page.
 */
@Controller
@Slf4j
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	@Inject
	private MemberService service;
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/gpt", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);

		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "GPT";
	}
	
	@RequestMapping(value = "/pdf", method = RequestMethod.GET)
	public String file(HttpServletRequest req, Locale locale, Model model) throws IOException {
		String filePath = req.getSession().getServletContext().getRealPath("/resources") + "/request.pdf";
//		String filePath = "../resources/doit.echoHandlerpdf";
//		ClassPathResource resource = new ClassPathResource(filePath);
//		ClassPathResource res = new ClassPathResource(path)
//		InputStream inputStream = resource.getInputStream();
		
		InputStream in = new FileInputStream(new File(filePath));
		
		Document pdf = new Document(in); 
		
		TextAbsorber textAbsorber = new TextAbsorber();
      
		pdf.getPages().accept(textAbsorber);
		
		String text = textAbsorber.getText();
		
		model.addAttribute("text", text );
		
		return "pdf";
	}
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String loginGet(Locale locale, Model model) {
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		return "login";
	}

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String loginPost(MemberVO vo ,Model model, HttpServletRequest req,Locale locale) {
		MemberVO member =  service.idCheck(vo);
		HttpSession session = req.getSession();
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		if(member!=null) {
			session.setAttribute("user", member);
		}
		return "newChat";
	}
	
}
