package com.jrzmq.core.rest;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;

import com.jrzmq.core.utils.HttpClientUtil;


/**
 * 财付通http或者https网络通信客户端<br/>
 * ========================================================================<br/>
 * api说明：<br/>
 * setReqContent($reqContent),设置请求内容，无论post和get，都用get方式提供<br/>
 * getResContent(), 获取应答内容<br/>
 * setMethod(method),设置请求方法,post或者get<br/>
 * getErrInfo(),获取错误信息<br/>
 * setCertInfo(certFile, certPasswd),设置证书，双向https时需要使用<br/>
 * setCaInfo(caFile), 设置CA，格式未pem，不设置则不检查<br/>
 * setTimeOut(timeOut)， 设置超时时间，单位秒<br/>
 * getResponseCode(), 取返回的http状态码<br/>
 * call(),真正调用接口<br/>
 * getCharset()/setCharset(),字符集编码<br/>
 * 
 * ========================================================================<br/>
 *
 */
@SuppressWarnings("unused")
public class HttpsClient {
    
    private static final String USER_AGENT_VALUE = 
        "Mozilla/4.0 (compatible; MSIE 6.0; Windows 7)";
        
    /** ca证书文件 */
	private File caFile;
    
    /** cer 证书文件 */
    private File cerFile;
    
    /** 证书密码 */
    private String caPasswd;
    
    /** 请求地址 */
    private String reqUrl;
    
    /** 应答内容 */
    private String resContent;
    
    /** 请求方法 */
    private String method;
    
    /** 错误信息 */
    private String errInfo;
    
    /** 超时时间,以秒为单位 */
    private int timeOut;
    
    /** http应答编码 */
    private int responseCode;
    
    /** 字符编码 */
    private String charset;
    
    private InputStream inputStream;
    
    public HttpsClient() {
        this.caFile = null;
        
        this.resContent = "";
        this.method = "POST";
        this.errInfo = "";
        this.timeOut = 30;//30秒
        
        this.responseCode = 0;
        this.charset = "UTF-8";
        
        this.inputStream = null;
    }

    /**
     * 设置ca
     * @param caFile
     */
    public void setCaInfo(File caFile) {
        this.caFile = caFile;
    }
    
    public void setReqUrl(String reqUrl) {
        this.reqUrl = reqUrl;
    }

    /**
     * 获取结果内容
     * @return String
     * @throws IOException 
     */
    public String getResContent() {
        try {
            this.doResponse();
        } catch (IOException e) {
            this.errInfo = e.getMessage();
            //return "";
        }
        
        return this.resContent;
    }
    
    /**
     * 设置请求方法post或者get
     * @param method 请求方法post/get
     */
    public void setMethod(String method) {
        this.method = method;
    }
    
    /**
     * 获取错误信息
     * @return String
     */
    public String getErrInfo() {
        return this.errInfo;
    }
    
    /**
     * 设置超时时间,以秒为单位
     * @param timeOut 超时时间,以秒为单位
     */
    public void setTimeOut(int timeOut) {
        this.timeOut = timeOut;
    }
    
    /**
     * 获取http状态码
     * @return int
     */
    public int getResponseCode() {
        return this.responseCode;
    }
    
    
    public void callHttps(String data) throws IOException, CertificateException,
            KeyStoreException, NoSuchAlgorithmException,
            UnrecoverableKeyException, KeyManagementException, NoSuchProviderException {

        FileInputStream cerFileInputStream = new FileInputStream(this.cerFile);

        SSLContext sslContext = HttpClientUtil.getSSLContext(cerFileInputStream);
        //关闭流
        cerFileInputStream.close();
        
        if("POST".equals(this.method.toUpperCase())) {
            
            this.httpsPostMethod(this.reqUrl, data.getBytes(this.charset), sslContext);
            
            return ;
        }
    }
    
    /**
     * 以http post方式通信
     * @param url
     * @param postData
     * @throws IOException
     */
    protected void httpPostMethod(String url, byte[] postData)
            throws IOException {

        HttpURLConnection conn = HttpClientUtil.getHttpURLConnection(url);

        this.doPost(conn, postData);
    }
    
    /**
     * 以http get方式通信
     * 
     * @param url
     * @throws IOException
     */
    protected void httpGetMethod(String url) throws IOException {
        
        HttpURLConnection httpConnection =
            HttpClientUtil.getHttpURLConnection(url);
        
        this.setHttpRequest(httpConnection);
        
        httpConnection.setRequestMethod("GET");
        
        this.responseCode = httpConnection.getResponseCode();
        
        this.inputStream = httpConnection.getInputStream();
        
    }
    
    /**
     * 以https get方式通信
     * @param url
     * @param sslContext
     * @throws IOException
     */
    protected void httpsGetMethod(String url, SSLContext sslContext)
            throws IOException {

        SSLSocketFactory sf = sslContext.getSocketFactory();

        HttpsURLConnection conn = HttpClientUtil.getHttpsURLConnection(url);

        conn.setSSLSocketFactory(sf);

        this.doGet(conn);

    }
    
    protected void httpsPostMethod(String url, byte[] postData,
            SSLContext sslContext) throws IOException {

        SSLSocketFactory sf = sslContext.getSocketFactory();

        HttpsURLConnection conn = HttpClientUtil.getHttpsURLConnection(url);

        conn.setSSLSocketFactory(sf);
        
        this.doPost(conn, postData);

    }
    
    /**
     * 设置http请求默认属性
     * @param httpConnection
     */
    protected void setHttpRequest(HttpURLConnection httpConnection) {
        
        //设置连接超时时间
        httpConnection.setConnectTimeout(this.timeOut * 1000);
        
        //User-Agent
        httpConnection.setRequestProperty("User-Agent", 
                HttpsClient.USER_AGENT_VALUE);
        
        //不使用缓存
        httpConnection.setUseCaches(false);
        
        //允许输入输出
        httpConnection.setDoInput(true);
        httpConnection.setDoOutput(true);
        
    }
    
    /**
     * 处理应答
     * @throws IOException
     */
    protected void doResponse() throws IOException {
        
        if(null == this.inputStream) {
            return;
        }

        //获取应答内容
        this.resContent=HttpClientUtil.InputStreamTOString(this.inputStream,this.charset); 

        //关闭输入流
        this.inputStream.close();
        
    }
    
    /**
     * post方式处理
     * @param conn
     * @param postData
     * @throws IOException
     */
    protected void doPost(HttpURLConnection conn, byte[] postData)
            throws IOException {

        // 以post方式通信
        conn.setRequestMethod("POST");

        // 设置请求默认属性
        this.setHttpRequest(conn);
        conn.setAllowUserInteraction(true);

        // Content-Type
        conn.setRequestProperty("Content-Type",
                "application/x-www-form-urlencoded");

        BufferedOutputStream out = new BufferedOutputStream(conn
                .getOutputStream());

        final int len = 1024; // 1KB
        HttpClientUtil.doOutput(out, postData, len);

        // 关闭流
        out.close();

        // 获取响应返回状态码
        this.responseCode = conn.getResponseCode();

        // 获取应答输入流
        this.inputStream = conn.getInputStream();

    }
    
    /**
     * get方式处理
     * @param conn
     * @throws IOException
     */
    protected void doGet(HttpURLConnection conn) throws IOException {
        
        //以GET方式通信
        conn.setRequestMethod("GET");
        
        //设置请求默认属性
        this.setHttpRequest(conn);
        
        //获取响应返回状态码
        this.responseCode = conn.getResponseCode();
        
        //获取应答输入流
        this.inputStream = conn.getInputStream();
    }

    /**
     * @param cerFile the cerFile to set
     */
    public void setCerFile(File cerFile) {
        this.cerFile = cerFile;
    }

    

}
