package com.situ.ow.service;

import com.situ.ow.common.EasyUIDataGrideResult;
import com.situ.ow.common.ServerResponse;
import com.situ.ow.pojo.Carousel;

import java.util.Date;
import java.util.List;

public interface ICarouselService {


    EasyUIDataGrideResult carouselList(Integer page, Integer rows, Carousel carousel, Date beginTime, Date endTime);

    List carouselList ();

    ServerResponse delete(String ids);

    ServerResponse add(Carousel carousel);

    ServerResponse update(Carousel carousel);

    ServerResponse findById(Integer id);

    ServerResponse query();

    ServerResponse updateStatus(Integer id, Integer status);


}
