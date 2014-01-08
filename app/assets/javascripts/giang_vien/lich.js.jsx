/** @jsx React.DOM */

//= require ./grade
//= require ./calendar
//= require ./lopsetting
//= require ./assignments
//= require ./lichgiangday
//= require ./dangkybosung

var DisabledEnrollment = React.createClass({
  render: function(){
    return (
      <tr>
        <td>{this.props.stt}</td>
        <td>{this.props.enrollment.name} ({this.props.enrollment.code})</td>        
        <td><div class="progress">
        <div class="progress-bar progress-bar-success" style={{width: this.props.enrollment.dihoc_tinhhinh +"%"}}>
          <span>{this.props.enrollment.dihoc_tinhhinh +"%"}</span>
        </div>        
        <div class="progress-bar progress-bar-danger" style={{width: this.props.enrollment.tinhhinh + "%"}}>
          <span>{this.props.enrollment.tinhhinh +"%"}</span>
        </div>
      </div></td>
        <td>x</td>        
        <td>x</td>
        <td>x</td>
        <td>x</td>
      </tr>
    );
  }
});
var Enrollment = React.createClass({   
  getInitialState: function(){
    return {value: this.props.enrollment.note};
  } , 
  handleChange: function(event){
    this.setState({value: event.target.value});
    return false;
  },
  onmsubmit: function(event){     
    var self = this;      
    this.props.ajax.loading = true;
    this.props.enrollment.note = this.state.value;
    this.forceUpdate();    
    setTimeout(function(){      
      self.props.on_note(self.props.enrollment, 'note');         
    }
      , 1200);    
    return false;
  },  
  render: function() {
    var css = {"Đang học": "btn btn-success btn-sm btn-block",
              "Vắng": "btn btn-danger btn-sm btn-block",
              "Trễ": "btn btn-warning btn-sm btn-block",
              "x": "btn btn-default btn-sm btn-block"};
    var phep = {"Có": "btn btn-success btn-sm btn-block",
    "Không": "btn btn-danger btn-sm btn-block",
    "x" : "btn btn-default btn-sm btn-block"};
    var idle = {"Có": "btn btn-success btn-sm btn-block", 
    "Không": "btn btn-danger btn-sm btn-block"};
    var value = this.state.value;    
    var plus = 'disabled';
    var minus = 'disabled';
    if (this.props.enrollment.idle_status === "Có" && parseInt(this.props.enrollment.so_tiet_vang) < parseInt(this.props.enrollment.max) && this.props.state === true && this.props.ajax.loading === false ) {plus = '';}
    if (this.props.enrollment.idle_status === "Có" && parseInt(this.props.enrollment.so_tiet_vang) > 0 && this.props.state === true && this.props.ajax.loading === false) {minus = '';}
    return (
      <tr>
        <td>{this.props.stt}</td>
        <td>{this.props.enrollment.name} ({this.props.enrollment.code})</td>        
        <td><div class="progress">
        <div class="progress-bar progress-bar-success" style={{width: this.props.enrollment.dihoc_tinhhinh +"%"}}>
          <span>{this.props.enrollment.dihoc_tinhhinh +"%"}</span>
        </div>        
        <div class="progress-bar progress-bar-danger" style={{width: this.props.enrollment.tinhhinh + "%"}}>
          <span>{this.props.enrollment.tinhhinh +"%"}</span>
        </div>
      </div></td>
        <td><button onClick={this.props.on_absent} disabled={this.props.enrollment.idle_status === "Không" || this.props.ajax.loading === true || this.props.enrollment.status === "Trễ" ? 'disabled' : ''}  class={css[this.props.enrollment.status]}>{this.props.enrollment.status}</button></td>        
        <td><button onClick={this.props.on_plus} class="btn btn-default btn-sm" disabled={plus === 'disabled' ? 'disabled' : ''}><span class="glyphicon glyphicon-plus"></span></button>{'   '}{this.props.enrollment.so_tiet_vang}{'   '}
        <button onClick={this.props.on_minus}  class="btn btn-default btn-sm" disabled={minus === 'disabled' ? 'disabled' : ''} ><span class="glyphicon glyphicon-minus"></span></button></td>
        <td><button disabled={this.props.enrollment.idle_status === "Không" && ( ( (this.props.enrollment.so_tiet_vang === 0 && this.props.state===true) || this.props.ajax.loading === true) ) ? 'disabled' : ''} onClick={this.props.on_phep} class={phep[this.props.enrollment.phep_status]}>{this.props.enrollment.phep_status}</button></td>
        <td><button onClick={this.props.on_idle} class={idle[this.props.enrollment.idle_status]}>{this.props.enrollment.idle_status}</button></td>
        <td><input type="text" value={value} onChange={this.handleChange}  /><button class="btn btn-primary btn-sm" onClick={this.onmsubmit} disabled={(this.props.ajax.loading === true && this.props.state === true ) ? 'disabled' : ''} >Cập nhật ghi chú</button></td>
      </tr>
    );
  }
});
var Enrollments = React.createClass({  
  handleVang: function(e,s){
    var self = this;
    this.props.loading = true;
    this.forceUpdate();
    setTimeout(function(){
      self.props.on_vang(e,s);  
    }, 1000);    
    return false;
  },  
  render: function(){      
    var self = this;
    var enrollments = this.props.data.map(function (enrollment, i) {
      if (self.props.state === false){
        return <DisabledEnrollment stt={i} key={enrollment.id} enrollment={enrollment} />
      } else {
        return <Enrollment state={self.props.state} stt={i} key={enrollment.id} enrollment={enrollment} on_absent={self.handleVang.bind(self,enrollment, 'vang')} on_plus={self.handleVang.bind(self,enrollment,'plus')} on_idle={self.handleVang.bind(self, enrollment, 'idle')} on_minus={self.handleVang.bind(self,enrollment,'minus')} on_phep={self.handleVang.bind(self,enrollment,'phep')} on_note={self.handleVang.bind(self,enrollment,'note')} ajax={ {loading: self.props.loading} } />;
      }      
    }); 
    return (
      <div>          
        <h6>Thông tin điểm danh:</h6>
        <div class="table-responsive">
        <table class="table table-bordered table-condensed">
          <colgroup>
            <col style={{width: "5%"}} />
            <col style={{width: "15%"}} />
            <col style={{width: "15%"}} />
            <col style={{width: "10%"}} />
            <col style={{width: "15%"}} />
            <col style={{width: "10%"}} />
            <col style={{width: "10%"}} />
            <col style={{width: "20%"}} />
          </colgroup>
          <thead>
            <td>Stt</td>
            <td>Sinh viên</td>            
            <td>Tình hình đi học</td>
            <td>Vắng</td>        
            <td>Số tiết vắng</td>
            <td>Phép</td>  
            <td>Bắt buộc tham dự</td>
            <td>Ghi chú</td>
          </thead>
          <tbody>
            {enrollments}
          </tbody>           
        </table>
        </div>
      </div>
    );
  }
});
var Lop = React.createClass({     
  componentDidMount: function(){
    React.renderComponent(<Assignments giang_vien={ENV.giang_vien_id} lop={ENV.lop_id} />
        , document.getElementById('assignment'));    
    React.renderComponent(<Bosung giang_vien={ENV.giang_vien_id} lop={ENV.lop_id} />, document.getElementById('bosung'));
    React.renderComponent(<Calendar giang_vien={ENV.giang_vien_id} lop={ENV.lop_id} />, document.getElementById('calendar'));
    React.renderComponent(<LopSetting giang_vien={ENV.giang_vien_id} lop={ENV.lop_id} />, document.getElementById('thongso'));
  },
  render: function(){        
    return(                
        <div class="panel-body">
          <ul class="nav nav-tabs">
            <li class="active">
              <a href="#home" data-toggle="tab">Thông tin chung</a>
            </li>
            <li>
              <a href="#thongso1" data-toggle="tab">Thiết lập thông số</a>
            </li>  
            <li>
              <a href="#assignments" data-toggle="tab">Thiết lập nhóm điểm</a>
            </li> 
            <li>
              <a href="#bs" data-toggle="tab">Đăng ký bổ sung</a>
            </li>
            <li>
              <a href="#calendar1" data-toggle="tab">Thời khóa biểu</a>
            </li>                                
          </ul>
      
          <div class="tab-content">
            <div class="tab-pane" id="assignments">
              <br />
              <div id="assignment">
                
              </div>
            </div>
            <div class="tab-pane" id="calendar1">
              <br />
              <div id="calendar">
                
              </div>
            </div>
            <div class="tab-pane" id="thongso1">
              <div id="thongso">
                
              </div>
            </div>
            <div class="tab-pane active" id="home">
              <br />
              <h6>Thông tin lớp học:</h6>        
              <div class="table-responsive">
                <table class="table table-bordered table-condensed">
                  <thead>
                    <td>Mã lớp</td>
                    <td>Tên môn học</td>
                    <td>Sĩ số</td>
                    <td>Số tiết lý thuyết</td>
                    <td>Số tiết thực hành</td>
                    <td>Trạng thái</td>              
                  </thead>
                  <tbody>
                      <td><a href={"/lop/"+this.props.lop.id}>{this.props.lop.ma_lop}</a></td>
                      <td>{this.props.lop.ten_mon_hoc}</td>
                      <td>{this.props.lop.si_so}</td>
                      <td>{this.props.lop.so_tiet_ly_thuyet}</td>
                      <td>{this.props.lop.so_tiet_thuc_hanh}</td>
                      <td>{this.props.lop.updated === true ? 'Đã cấu hình' : 'Chưa cấu hình'}</td>              
                  </tbody>           
                </table>
              </div>     
            </div>     
            <div class="tab-pane" id="bs">
              <div id="bosung">
                
              </div>
            </div>
          </div>
          
      </div>
      );
  }
});
var DisabledEditor = React.createClass({
  render: function(){
    return (
        <div style={{'border-right': '2px solid blue'}}>
        <div id='content-header' >
          <p><span dangerouslySetInnerHTML={{__html: this.props.lich.content_html}} /></p>         
        </div>        
        <h4>Các buổi đã dạy</h4>
        <LichGiangDay state={this.props.lich.updated} giang_vien={this.props.giang_vien} lop={this.props.lop} />
        </div>
      );
  }
});
var Editor = React.createClass({
  getInitialState: function(){      
      return {content: '', edit: 0};
  },      
  loadData: function(){
    $.ajax({
      url: "/lich/" + this.props.lich +"/noidung.json",            
      success: function(data) {             
        this.setState({content: data.lich.content, edit: 0});         
      }.bind(this)
    });
  },
  componentDidMount: function(){
    this.loadData();
  },
  componentDidUpdate: function(){        
    if (this.state.edit == 1){
      this.refs.editor.getDOMNode().value = this.state.content;      
    }
  },
  handleEdit: function(e){
    this.setState({edit: 1});
  },
  handleUpdate: function(e){
    var content = this.refs.editor.getDOMNode().value;
    var data = {
      id: this.props.lich,
      content: content
    }
    $.ajax({
      url: "/lich/noidung",
      type: 'POST',
      data: data,
      success: function(data) {             
        this.setState({content: data.lich.content, edit: 0});         
      }.bind(this)
    });
  },
  handleCancel: function(e){
    this.setState({edit: 0});
  },
  render: function() {
    if (this.state.edit === 0){
      return (
        <div style={{'border-right': '2px solid blue'}}>
        <div id='content-header' >
          <p><span dangerouslySetInnerHTML={{__html: this.state.content.replace(/(\r\n|\n|\r)/gm, "<br/>") }} /></p>
          <button onClick={this.handleEdit} class="btn btn-sm btn-default">Sửa nội dung</button>
        </div>        
        <h4>Các buổi đã dạy</h4>
        <LichGiangDay state={this.props.lich.updated} giang_vien={this.props.giang_vien} lop={this.props.lop} />
        </div>
      );
    } else {
      return (     
        <div>   
        <div id='content-header'>
          <textarea id='editor' ref='editor' className='expanding' placeholder='Share whats new...' style={{width: '100%', minHeight: 200}}>
          </textarea>          
        </div>      
        <br />
        <button onClick={this.handleCancel} class="btn btn-sm btn-warning">Hủy</button>
          <button onClick={this.handleUpdate} class="btn btn-sm btn-primary">Cập nhật</button>
          <br />
          <h4>Các buổi đã dạy</h4>
        <LichGiangDay giang_vien={this.props.giang_vien} lop={ENV.lop_id} />
          </div>
      );
    }    
  }
});

var LichSetting = React.createClass({  
  getInitialState: function(){
    return {edit: 0};
  },
  handleEdit: function(e){
    this.setState({edit: 1});
  },
  handleCancelEdit: function(e){
    this.setState({edit: 0});
  },
  handleCapnhat: function(e){
    var phong = this.refs.phong.getDOMNode().value;
    var thuc_hanh = this.refs.thuc_hanh.getDOMNode().value;
    var so_tiet = this.refs.so_tiet.getDOMNode().value;
    this.props.onCapnhat({id: this.props.lich.id, phong: phong, thuc_hanh: thuc_hanh, so_tiet: so_tiet});
    this.setState({edit: 0});
  },
  handleComplete: function(e){
    this.props.onComplete(this.props.lich);
  },
  handleNghiday: function(e){
    this.props.onNghiday(this.props.lich);
  },
  componentDidUpdate: function(){
    if (this.state.edit === 1){
      this.refs.phong.getDOMNode().value = this.props.lich.phong;
      this.refs.thuc_hanh.getDOMNode().value = this.props.lich.thuc_hanh;
      this.refs.so_tiet.getDOMNode().value = this.props.lich.so_tiet;
    }
  },
  render: function(){    
    if (this.state.edit === 0){              
      return (        
        <div class="table-responsive">
          <table class="table table-bordered">
            <thead>
              <td>Phòng</td>
              <td>Thực hành</td>
              <td>Số tiết</td>
              <td>Số sinh viên có mặt</td>
              <td>Số sinh viên vắng</td>
              <td>Loại</td>
              <td>Trạng thái</td>
              <td>Thao tác</td>
            </thead>
            <tbody>
              <tr>
                <td>{this.props.lich.phong}</td>
                <td>{this.props.lich.thuc_hanh === false ? 'Lý thuyết' : 'Thực hành'}</td>
                <td>{this.props.lich.so_tiet}</td>
                <td>{this.props.lich.sv_co_mat}</td>
                <td>{this.props.lich.sv_vang_mat}</td>
                <td>{this.props.lich.alias_state}</td>
                <td>{this.props.lich.alias_status}</td>
                <td>
                  {this.props.lich.updated ? <div><button onClick={this.handleEdit} class="btn btn-sm btn-success">Sửa</button><button onClick={this.handleComplete} class="btn btn-sm btn-primary">Hoàn thành</button></div> : '' }                  
                </td>                            
              </tr>
            </tbody>
          </table>
        </div>
      );
    } else {
      return (
        <div class="table-responsive">
          <table class="table table-bordered">
            <thead>
              <td>Phòng</td>
              <td>Thực hành</td>
              <td>Số tiết</td>
              <td>Số sinh viên có mặt</td>
              <td>Số sinh viên vắng</td>
              <td>Thao tác</td>
            </thead>
            <tbody>
              <tr>
                <td><input type="text" ref="phong" /></td>
                <td><select ref="thuc_hanh" class="form-control input-sm">
                    <option value="false">Lý thuyết</option>
                    <option value="true">Thực hành</option>
                  </select></td>
                <td><input type="text" ref="so_tiet" /></td>
                <td>{this.props.lich.sv_co_mat}</td>
                <td>{this.props.lich.sv_vang_mat}</td>
                <td><button onClick={this.handleCancelEdit} class="btn btn-sm btn-success">Hủy</button><button onClick={this.handleCapnhat} class="btn btn-sm btn-primary">Cập nhật</button></td>                            
              </tr>
            </tbody>
          </table>
        </div>
      );    
    }
  }
});

var Lich = React.createClass({      
  loadEnrollmentsFromServer: function(){    
    $.ajax({
      url: "/lich/"+this.props.lich+"/attendances.json" ,
      success: function(data2) {                      
        this.setState({noidung: data2.info.lich.content,data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false});         
      }.bind(this)
    });    
  },  
  componentWillMount: function() {
    this.loadEnrollmentsFromServer();  
  },
  componentDidMount: function(){
    React.renderComponent(<Grade giang_vien={ENV.giang_vien_id} lop={ENV.lop_id} />, document.getElementById('grades'));
  },
  getInitialState: function() {
    return {data: [], lich: {}, lop: {}, loading: false };
  },      
  handleSettingLop: function(lop){
    var d = {                  
      lich_id: this.state.lich.id,
      lop: lop
    }; 
    $.ajax({
      url: "/lich/"+this.props.lich+"/settinglop",
      type: 'POST',
      data: d,
      success: function(data2) {             
        this.setState({noidung: data2.info.lich.content,data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false}); 
        //alert(data.so_tiet_vang);
      }.bind(this)
    });
    return false;
  },
  handleVang: function(enrollment, stat){    
    var d = {            
      stat: stat,
      lich_id: this.state.lich.id,
      enrollment: enrollment
    };    
    $.ajax({
      url: "/lich/"+this.props.lich+"/attendances",
      type: 'POST',
      data: d,
      success: function(data2) {             
        this.setState({noidung: data2.info.lich.content, data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false}); 
        //alert(data.so_tiet_vang);
      }.bind(this)
    });
    return false;
  },  
  handleChangeContent: function(e){
    this.setState({noidung: e.target.value});
    this.state.lich.content = this.state.noidung;
  },
  handleCapnhat: function(d){
    d.giang_vien = this.props.giang_vien;
    d.lop_id = this.props.lop;
    $.ajax({
            url: "/lop/" + this.props.lop + "/lich_trinh_giang_days/capnhat",
              type: 'POST',
              data: d,
              success: function(data2) {             
                  this.setState({noidung: data2.info.lich.content, data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false}); 
              }.bind(this)           
          }); 
  },
  handleComplete: function(d){
    d.giang_vien = this.props.giang_vien;
    d.lop_id = this.props.lop;
    $.ajax({
            url: "/lop/" + this.props.lop + "/lich_trinh_giang_days/complete",
              type: 'POST',
              data: d,
              success: function(data2) {             
                  this.setState({noidung: data2.info.lich.content, data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false}); 
              }.bind(this)           
          }); 
  },  
  render: function(){      
    
    return (      
      <div class="panel-group" id="accordion">
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title"> 
        <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">       
          Thông tin lớp học        
        </a>
      </h4>
    </div>
    <div id="collapseOne" class="panel-collapse collapse">
      <div class="panel-body">
        <Lop lop={this.state.lop} onSettingLop={this.handleSettingLop} />
        
      </div>
    </div>    
  </div>      

        

  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title">
         <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
          Điểm danh
          </a>
      </h4>
    </div>
    <div id="collapseTwo" class="panel-collapse collapse in">
      <div class="panel-body">
        <ul class="nav nav-tabs">
          <li class="active">
            <a href="#home2" data-toggle="tab">Điểm danh</a>
          </li>
          <li>
            <a href="#noidung" data-toggle="tab">Nội dung giảng dạy</a>
          </li>          
        </ul>
    
        <div class="tab-content">
          <div class="tab-pane active" id="home2">
            <br />
            <h6>Thông tin buổi học</h6>
            <LichSetting lich={this.state.lich} onNghiday={this.handleNghiday} onCapnhat={this.handleCapnhat} onComplete={this.handleComplete} />
            <br />
            <Enrollments state={this.state.lich.updated===true && this.state.lop.updated===true} data={this.state.data} on_vang={this.handleVang} loading={this.state.loading}/>
          </div>                  
          <div class="tab-pane" id="noidung">
            <br />
            <h6>Thông tin buổi học</h6>
                <LichSetting lich={this.state.lich} onCapnhat={this.handleCapnhat} onNghiday={this.handleNghiday} onComplete={this.handleComplete} />
                <br />
            <div class="row">
              <div class="col-sm-6">
                <br />                
               {this.state.lich.updated === true ? <Editor lich={this.props.lich} lop={this.props.lop} giang_vien={this.props.giang_vien} /> : <DisabledEditor lich={this.props.lich} lop={this.props.lop} giang_vien={this.props.giang_vien} />}
              </div>
              <div class="col-sm-6">
                <span dangerouslySetInnerHTML={{__html: this.state.lop.de_cuong_du_kien }} />
              </div>
            </div>
          </div>                
        </div>
       </div>
    </div>
  </div>
  
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title"> 
        <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">       
          Điểm
        </a>
      </h4>
    </div>
    <div id="collapseThree" class="panel-collapse collapse">
      <div class="panel-body">
        <div id="grades">
          
        </div>
      </div>
    </div>    
  </div>
  </div>
    );    
  }
});

//var init = {"lich":{"id":1,"phong":null,"noi_dung":null,"state":"started","sv_co_mat":0,"sv_vang_mat":0,"so_tiet":3,"so_tiet_moi":3,"thuc_hanh":null},"enrollments":[{"id":1,"name":"ho1 dem1 ten1","code":"sv1","status":"Vắng","so_tiet_vang":3,"phep":null,"max":3},{"id":2,"name":"ho2 dem2 ten2","code":"sv2","status":"Vắng","so_tiet_vang":3,"phep":null,"max":3}]}
/*
$.ajax({
      url: "/lich/1/enrollments.json" ,
      success: function(data) {                      
        React.renderComponent(  
          <Lich lich={ENV.lich_id} lich={data} />,
          document.getElementById('main')
        );           
      }
});    
*/
React.renderComponent(  
  <Lich lich={ENV.lich_id} lop={ENV.lop_id} giang_vien={ENV.giang_vien_id} />,
  document.getElementById('main')
);  
   