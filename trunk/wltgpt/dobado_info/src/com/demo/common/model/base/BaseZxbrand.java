package com.demo.common.model.base;

import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.IBean;

/**
 * Generated by JFinal, do not modify this file.
 */
@SuppressWarnings("serial")
public abstract class BaseZxbrand<M extends BaseZxbrand<M>> extends Model<M> implements IBean {

	public void setBrandId(java.lang.Integer brandId) {
		set("brandId", brandId);
	}

	public java.lang.Integer getBrandId() {
		return get("brandId");
	}

	public void setBrandName(java.lang.String brandName) {
		set("brandName", brandName);
	}

	public java.lang.String getBrandName() {
		return get("brandName");
	}

	public void setBrandImg(java.lang.String brandImg) {
		set("brandImg", brandImg);
	}

	public java.lang.String getBrandImg() {
		return get("brandImg");
	}

	public void setBrandUrl(java.lang.String brandUrl) {
		set("brandUrl", brandUrl);
	}

	public java.lang.String getBrandUrl() {
		return get("brandUrl");
	}

	public void setSortnum(java.lang.Integer sortnum) {
		set("sortnum", sortnum);
	}

	public java.lang.Integer getSortnum() {
		return get("sortnum");
	}

}
