package cn.digirun.component.order.service.repository;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

import cn.digirun.component.order.model.CartModel;

@Repository
public interface CartRepository extends PagingAndSortingRepository<CartModel, Long>{
  
	CartModel findByUserId(Long userId);
}
