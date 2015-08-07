package egovframework.got.com.web.controller;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.got.com.bean.AbstractController;
import egovframework.got.com.web.util.EgovFileUploadUtil;
import egovframework.got.com.web.util.EgovFormBasedFileUtil;
import egovframework.got.com.web.util.EgovFormBasedFileVo;
import egovframework.rte.fdl.property.EgovPropertyService;

@Controller
public class EgovWebEditorImageController extends AbstractController{

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;

	@RequestMapping(value = { "/utl/wed/insertImage.do" }, method={org.springframework.web.bind.annotation.RequestMethod.GET})
	public ModelAndView goInsertImage(){
		return new ModelAndView("/common/EgovInsertImage_notiles");
	}


  @RequestMapping(value={"/utl/wed/insertImage.do"}, method={org.springframework.web.bind.annotation.RequestMethod.POST})
  public String imageUpload(HttpServletRequest request, Model model)
    throws Exception
  {
    List list = EgovFileUploadUtil.uploadFiles(request, propertyService.getString("Globals.fileStorePath"), 104857600L);

    if (list.size() > 0) {
      EgovFormBasedFileVo vo = (EgovFormBasedFileVo)list.get(0);

      String url = request.getContextPath() + 
        "/utl/web/imageSrc.do?" + 
        "path=" + vo.getServerSubPath() + 
        "&physical=" + vo.getPhysicalName() + 
        "&contentType=" + vo.getContentType();

      model.addAttribute("url", url);
    }

    return "/common/EgovInsertImage_notiles";
  }

  @RequestMapping(value={"/utl/web/imageSrc.do"}, method={org.springframework.web.bind.annotation.RequestMethod.GET})
  public void download(HttpServletRequest request, HttpServletResponse response)
    throws Exception
  {
    String subPath = request.getParameter("path");
    String physical = request.getParameter("physical");
    String mimeType = request.getParameter("contentType");

    EgovFormBasedFileUtil.viewFile(response, propertyService.getString("Globals.fileStorePath"), subPath, physical, mimeType);
  }

}
