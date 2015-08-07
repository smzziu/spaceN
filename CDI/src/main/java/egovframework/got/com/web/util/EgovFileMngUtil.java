package egovframework.got.com.web.util;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.fdl.property.EgovPropertyService;

import java.io.FileNotFoundException;

/**
 * @Class Name  : EgovFileMngUtil.java
 * @Description : 메시지 처리 관련 유틸리티
 * @Modification Information
 * 
 *     수정일         수정자                   수정내용
 *     -------          --------        ---------------------------
 *   2009.02.13       이삼섭                  최초 생성
 *
 * @author 공통 서비스 개발팀 이삼섭
 * @since 2009. 02. 13
 * @version 1.0
 * @see 
 * 
 */
@Component("EgovFileMngUtil")
public class EgovFileMngUtil {

    //public static final int BUFF_SIZE = 2048;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
/*
    @Resource(name = "egovFileIdGnrService")
    private EgovIdGnrService idgenService;
*/    
    Logger log = Logger.getLogger(this.getClass());

    public List<FileVO> parseFileInf(HttpServletRequest req) throws Exception {
    	
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest)req;
		final Map<String, MultipartFile> files = multiRequest.getFileMap();		
		List<FileVO> _result = null;
		
		if(!files.isEmpty()){
			_result = parseFileInf(files); 
		}
		return _result;
    }
    public List<FileVO> parseFileInf(Map<String, MultipartFile> files) throws Exception {
    	
    	return parseFileInf(files,  "");
    }
    /**
     * 첨부파일에 대한 목록 정보를 취득한다.
     * 
     * @param files
     * @return
     * @throws Exception
     */
    //public List<FileVO> parseFileInf(Map<String, MultipartFile> files, String KeyStr, int fileKeyParam, String atchFileId, String storePath) throws Exception {
    public List<FileVO> parseFileInf(Map<String, MultipartFile> files, String storePath) throws Exception {
		int fileKey = 0;
		
		String storePathString = "";
		String atchFileIdString = "";
		
		if ("".equals(storePath) || storePath == null) {
		    storePathString = propertyService.getString("Globals.fileStorePath");
		} else {
		    storePathString = propertyService.getString(storePath);
		}
		//저장경로 + 년 + 월 + 일
		String createDateDir = createDateDir(true);
		storePathString += createDateDir;

	
		File saveFolder = new File(storePathString);
		
		if (!saveFolder.exists() || saveFolder.isFile()) {
		    saveFolder.mkdirs();
		}
	
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		MultipartFile file;
		String filePath = "";
		List<FileVO> result  = new ArrayList<FileVO>();
		FileVO fvo;
	
		while (itr.hasNext()) {
		    Entry<String, MultipartFile> entry = itr.next();
	
		    file = entry.getValue();
		    String orginFileName = file.getOriginalFilename();
		    //--------------------------------------
		    // 원 파일명이 없는 경우 처리
		    // (첨부가 되지 않은 input file type)
		    //--------------------------------------
		    if ("".equals(orginFileName)) {
		    	continue;
		    }
		    ////------------------------------------
	
		    int index = orginFileName.lastIndexOf(".");
		    String fileExt = "";
		    //String newName = idgenService.getNextStringId();
		    String newName = getPhysicalFileName();
		    atchFileIdString = newName;
		    if(index >  -1){
		    	fileExt = orginFileName.substring(index + 1);
		    	newName = newName + "." + fileExt;
		    }

		    long _size = file.getSize();
	
		    
			filePath = storePathString + newName;
			file.transferTo(new File(filePath));
		    
		    fvo = new FileVO();
		    //파일 확장자
		    fvo.setFileExtsn(fileExt.toUpperCase());
		    //저장경로(property에 설정된 경로 제외)
		    fvo.setFileStreCours(createDateDir);
		    //파일 사이즈
		    fvo.setFileMg(Long.toString(_size));
		    //원본파일명
		    fvo.setOrignlFileNm(orginFileName);
		    //업로드 파일명
		    fvo.setStreFileNm(newName);
		    //확장자 제외한 파일명
		    fvo.setAtchFileId(atchFileIdString);
		    //파일 seq
		    fvo.setFileSn(String.valueOf(fileKey));
		    //업로드시 필드명
		    fvo.setFieldNm(file.getName());
		    //저장 Full Path(경로 + 파일명 + 확장자 포함)
		    fvo.setFileFullPath(filePath);
		    //파일의 ContentType
		    fvo.setContentType(file.getContentType());
		    

		    result.add(fvo);
		    
		    fileKey++;
		}
	
		return result;
    }

    
    /** 
     * 날짜에 따른 디렉토리명 구하기 
     * 
     * /dirName/2005/04/10
     **/
    private String createDateDir(boolean isLastSeparator)throws Exception{
    	SimpleDateFormat format = new SimpleDateFormat("yyyy"+File.separator+"MM"+File.separator+"dd", Locale.getDefault());
        
        String path = format.format(new Date());
        
        if(isLastSeparator) path += File.separator;
        
        return path;
    }

    /**
     * 물리적 파일명 생성.
     * @return
     */
    public static String getPhysicalFileName() {
    	return EgovFormBasedUUID.randomUUID().toString().replaceAll("-", "").toUpperCase();
    }
    
/*    
    public String getHostName(){
    	String hostName = "hostname";
		try{
			hostName = java.net.InetAddress.getLocalHost().getHostName();
		}catch(Exception e){}
		return hostName;
    }*/
    
    /**
     * 서버 파일을 삭제한다.
     * 
     * @param response
     * @param streFileNm
     *            : 파일저장 경로가 포함된 형태
     * @param orignFileNm
     * @throws Exception
     */
    public void deleteFile(FileVO fvo) throws Exception {

	    String path = fvo.getFileStreCours();
	    String fileNm = fvo.getStreFileNm();
	
	    File file = new File(path+fileNm);
		
		if (!file.exists()) {
		    throw new FileNotFoundException(path+fileNm);
		}
	
		if (!file.isFile()) {
		    throw new FileNotFoundException(path+fileNm);
		}
		
		// 파일삭제
		file.delete();
		
    }
}
