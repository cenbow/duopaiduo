package cn.digirun.component.item.service.util.OSS;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.aliyun.oss.OSSClient;
import com.aliyun.oss.model.Bucket;
import com.aliyun.oss.model.OSSObject;
import com.aliyun.oss.model.ObjectMetadata;
import com.aliyun.oss.model.PutObjectResult;

public class OSSUtil {

	private static final Logger LOG = LoggerFactory.getLogger(OSSUtil.class); 
	
	public static final OSSClient getOSSClient() {
		return new OSSClient(OSSConfig.endpoint, OSSConfig.accesskey_id, OSSConfig.accesskey_secret);
	}
	
	/** 
     * 新建Bucket  --Bucket权限:私有 
     * @param bucketName bucket名称 
     * @return true 新建Bucket成功 
     * */  
    public static final boolean createBucket(String bucketName){  
        Bucket bucket = getOSSClient().createBucket(bucketName);   
        return bucketName.equals(bucket.getName());  
    }
    
    /** 
     * 删除Bucket  
     * @param bucketName bucket名称 
     * */ 
    public static final void deleteBucket(String bucketName){  
    	getOSSClient().deleteBucket(bucketName);   
        LOG.info("删除" + bucketName + "Bucket成功");  
    }

    /** 
     * 向阿里云的OSS存储中存储文件  --file也可以用InputStream替代 
     * @param client OSS客户端 
     * @param file 上传文件 
     * @param bucketName bucket名称 
     * @param diskName 上传文件的目录  --bucket下文件的路径 
     * @return String 唯一MD5数字签名 
     * */  
    public static final String uploadObject2OSS(File file, String bucketName, String diskName) {  
        String resultStr = null;  
        try {  
            InputStream is = new FileInputStream(file);  
            String fileName = file.getName();  
            Long fileSize = file.length();  
            //创建上传Object的Metadata  
            ObjectMetadata metadata = new ObjectMetadata();  
            metadata.setContentLength(is.available());  
            metadata.setCacheControl("no-cache");  
            metadata.setHeader("Pragma", "no-cache");  
            metadata.setContentEncoding("utf-8");  
            metadata.setContentType(getContentType(fileName));  
            metadata.setContentDisposition("filename/filesize=" + fileName + "/" + fileSize + "Byte.");  
            //上传文件   
            PutObjectResult putResult = getOSSClient().putObject(bucketName, diskName + fileName, is, metadata);  
            //解析结果  
            resultStr = putResult.getETag();  
        } catch (Exception e) {  
            LOG.error("上传阿里云OSS服务器异常." + e.getMessage(), e);  
        }  
        return resultStr;  
    }  
      
    /**  
     * 根据key获取OSS服务器上的文件输入流 
     * @param client OSS客户端 
     * @param bucketName bucket名称 
     * @param diskName 文件路径 
     * @param key Bucket下的文件的路径名+文件名 
     */    
     public static final InputStream getOSS2InputStream(String bucketName, String diskName, String key){   
        OSSObject ossObj = getOSSClient().getObject(bucketName, diskName + key);  
        return ossObj.getObjectContent();     
     }    
      
   /**  
    * 根据key删除OSS服务器上的文件  
    * @param client OSS客户端 
    * @param bucketName bucket名称 
    * @param diskName 文件路径 
    * @param key Bucket下的文件的路径名+文件名 
    */    
      public static void deleteFile(String bucketName, String diskName, String key){    
    	getOSSClient().deleteObject(bucketName, diskName + key);   
        LOG.info("删除" + bucketName + "下的文件" + diskName + key + "成功");  
      }    
       
    /**  
     * 通过文件名判断并获取OSS服务文件上传时文件的contentType  
     * @param fileName 文件名 
     * @return 文件的contentType    
     */    
     public static final String getContentType(String fileName){    
        String fileExtension = fileName.substring(fileName.lastIndexOf("."));  
        if("bmp".equalsIgnoreCase(fileExtension)) return "image/bmp";  
        if("gif".equalsIgnoreCase(fileExtension)) return "image/gif";  
        if("jpeg".equalsIgnoreCase(fileExtension) || "jpg".equalsIgnoreCase(fileExtension)  || "png".equalsIgnoreCase(fileExtension) ) return "image/jpeg";  
        if("html".equalsIgnoreCase(fileExtension)) return "text/html";  
        if("txt".equalsIgnoreCase(fileExtension)) return "text/plain";  
        if("vsd".equalsIgnoreCase(fileExtension)) return "application/vnd.visio";  
        if("ppt".equalsIgnoreCase(fileExtension) || "pptx".equalsIgnoreCase(fileExtension)) return "application/vnd.ms-powerpoint";  
        if("doc".equalsIgnoreCase(fileExtension) || "docx".equalsIgnoreCase(fileExtension)) return "application/msword";  
        if("xml".equalsIgnoreCase(fileExtension)) return "text/xml";  
        return "text/html";    
     } 

}
