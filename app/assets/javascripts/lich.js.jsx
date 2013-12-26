/** @jsx React.DOM */

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
      this.forceUpdate();         
    }
      , 1200);    
    return false;
  },  
  render: function() {
    var css = {"Không vắng": "btn btn-success btn-sm",
              "Vắng": "btn btn-danger btn-sm",
              "Trễ": "btn btn-warning btn-sm",
              "Không học": "btn btn-primary btn-sm"};
    var phep = {"Có phép": "btn btn-success btn-sm",
    "Không phép": "btn btn-danger btn-sm",
    "x" : "btn btn-default btn-sm"};
    var value = this.state.value;
    var ud = "Cập nhật";
    if (this.props.ajax.loading == true) {ud = "loading...";}
    if (this.props.ajax.loading == false) {ud = "Cập nhật";}
    var plus = 'disabled';
    var minus = 'disabled';
    if (parseInt(this.props.enrollment.so_tiet_vang) < parseInt(this.props.enrollment.max) && this.props.state === true ) {plus = '';}
    if (parseInt(this.props.enrollment.so_tiet_vang) > 0 && this.props.state === true) {minus = '';}
    return (
      <tr>
        <td>{this.props.stt}</td>
        <td>{this.props.enrollment.name} ({this.props.enrollment.code})</td>        
        <td>{this.props.enrollment.tong_vang}</td>
        <td><button onClick={this.props.on_absent}  class={css[this.props.enrollment.status]}>{this.props.enrollment.status}</button></td>        
        <td><button onClick={this.props.on_plus} class="btn btn-default btn-sm" disabled={plus === 'disabled' ? 'disabled' : ''}><span class="glyphicon glyphicon-plus"></span></button>{'   '}{this.props.enrollment.so_tiet_vang}{'   '}
        <button onClick={this.props.on_minus}  class="btn btn-default btn-sm" disabled={minus === 'disabled' ? 'disabled' : ''} ><span class="glyphicon glyphicon-minus"></span></button></td>
        <td><button disabled={(this.props.enrollment.so_tiet_vang === 0 && this.props.state===true) ? 'disabled' : ''} onClick={this.props.on_phep} class={phep[this.props.enrollment.phep_status]}>{this.props.enrollment.phep_status}</button></td>
        <td><input type="text" value={value} onChange={this.handleChange}  /><button class="btn btn-primary btn-sm" onClick={this.onmsubmit} disabled={(this.props.ajax.loading === true && this.props.state === true ) ? 'disabled' : ''} >{ud}</button></td>
      </tr>
    );
  }
});
var Enrollments = React.createClass({  
  handleVang: function(e,s){    
    this.props.on_vang(e,s);
    return false;
  },  
  render: function(){      
    var self = this;
    var enrollments = this.props.data.map(function (enrollment, i) {
      return <Enrollment state={self.props.state} stt={i} key={enrollment.id} enrollment={enrollment} on_absent={self.handleVang.bind(self,enrollment, 'vang')} on_plus={self.handleVang.bind(self,enrollment,'plus')} on_minus={self.handleVang.bind(self,enrollment,'minus')} on_phep={self.handleVang.bind(self,enrollment,'phep')} on_note={self.handleVang.bind(self,enrollment,'note')} ajax={ {loading: self.props.loading} } />;
    }); 
    return (
      <div>          
        <h6>Thông tin điểm danh:</h6>
        <table class="table table-bordered table-condensed">
          <thead>
            <td>Stt</td>
            <td>Sinh viên</td>            
            <td>Tình hình đi học</td>
            <td>Vắng</td>        
            <td>Số tiết vắng</td>
            <td>Phép</td>  
            <td>Ghi chú</td>
          </thead>
          <tbody>
            {enrollments}
          </tbody>           
        </table>
      </div>
    );
  }
});
var Lop = React.createClass({  
  handleSubmit: function() {
    var lt = this.refs.lt.getDOMNode().value.trim();
    var th = this.refs.th.getDOMNode().value.trim();
    if (!lt || !th) {
      return false;
    }
    this.props.lop.so_tiet_ly_thuyet = lt;
    this.props.lop.so_tiet_thuc_hanh = th;    
    this.props.onSettingLop(this.props.lop);
    this.setState({lt: lt, th: th});
    return false;
  },  
  render: function(){        
    return(
        <div>          
        <h6>Thông tin lớp học:</h6>
        <form className="settingForm" onSubmit={this.handleSubmit}>
        <table class="table table-bordered table-condensed">
          <thead>
            <td>Mã lớp</td>
            <td>Tên môn học</td>
            <td>Sĩ số</td>
            <td>Số tiết lý thuyết</td>
            <td>Số tiết thực hành</td>
            <td>Trạng thái</td>  
            <td>Cập nhật</td>                  
          </thead>
          <tbody>
              <td><a href={"/lop/"+this.props.lop.id}>{this.props.lop.ma_lop}</a></td>
              <td>{this.props.lop.ten_mon_hoc}</td>
              <td>{this.props.lop.si_so}</td>
              <td><input type="text"  ref="lt" placeholder={this.props.lop.so_tiet_ly_thuyet}  /></td>
              <td><input type="text"  ref="th" placeholder={this.props.lop.so_tiet_thuc_hanh}  /></td>
              <td>{this.props.lop.updated === true ? 'Đã cấu hình' : 'Chưa cấu hình'}</td>
              <td><input class="btn btn-primary btn-sm" type="submit" value="Cập nhật" /></td>
          </tbody>           
        </table>
        </form>
      </div>
      );
  }
});

var NoiDung = React.createClass({  
  getInitialState: function(){
    return {noi_dung: this.props.lich.content};
  },
  handleChange: function(event){
    var text = this.refs.noidung.getDOMNode().value; 
    this.props.lich.content = text;
  },
  handleND: function(event){
    var text = this.refs.noidung.getDOMNode().value; 
    if (!text ) {
      return false;
    }
    this.props.lich.content = text;
    this.props.onNoidung(this.props.lich);
    return false;
  }, 
  componentDidMount: function(){
    var editor = this.refs.noidung;
    editor.getDOMNode().focus();
  },
  render: function(){        
    return (
      <div class="row">
        <div class="col-sm-6">
          <form onSubmit={this.handleND}>
            <textarea onChange={this.handleChange}  ref="noidung" style={{minHeight: 100}}></textarea><br />
            <input class="btn btn-primary btn-sm" type="submit" value="Cập nhật" />
          </form>
        </div>
        <div class="col-sm-6">
          <span dangerouslySetInnerHTML={{__html: this.props.lich.content}} />
        </div>
      </div>
    );
  }
});

var Lich = React.createClass({    
  loadEnrollmentsFromServer: function(){    
    $.ajax({
      url: "/lich/"+this.props.lich+"/enrollments.json" ,
      success: function(data2) {                      
        this.setState({data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false}); 
      }.bind(this)
    });    
  },
  componentWillMount: function() {
    this.loadEnrollmentsFromServer();  
  },
  getInitialState: function() {
    return {data: [], lich: {}, lop: {}, loading: false };
  },    
  handleNoiDung: function(lich){
    $.ajax({
      url: "/lich/noidung",
      type: 'POST',
      data: lich,
      success: function(data2) {             
        this.setState({data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false}); 
        //alert(data.so_tiet_vang);
      }.bind(this)
    });
    return false;
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
        this.setState({data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false}); 
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
      url: "/lich/"+this.props.lich+"/enrollments",
      type: 'POST',
      data: d,
      success: function(data2) {             
        this.setState({data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false}); 
        //alert(data.so_tiet_vang);
      }.bind(this)
    });
    return false;
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
    <div id="collapseOne" class="panel-collapse collapse in">
      <div class="panel-body">
        <Lop lop={this.state.lop} onSettingLop={this.handleSettingLop} />
        </div>
    </div>
  </div>
        <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
          Thông tin buổi học
        </a>
      </h4>
    </div>
    <div id="collapseTwo" class="panel-collapse collapse">
      <div class="panel-body">
        <h6>Thông tin buổi học</h6>
        <table class="table table-bordered">
          <thead>
            <td>Phòng</td>
            <td>Thực hành</td>
            <td>Số sinh viên có mặt</td>
            <td>Số sinh viên vắng</td>
            <td>Cập nhật</td>
          </thead>
          <tbody>
            <tr>
              <td>{this.state.lich.phong}</td>
              <td>{this.state.lich.thuc_hanh}</td>
              <td>{this.state.lich.sv_co_mat}</td>
              <td>{this.state.lich.sv_vang_mat}</td>
              <td>Cập nhật</td>
            </tr>
          </tbody>
        </table>
        </div>
    </div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">
          Điểm danh
        </a>
      </h4>
    </div>
    <div id="collapseThree" class="panel-collapse collapse">
      <div class="panel-body">
        <ul class="nav nav-tabs">
          <li class="active">
            <a href="#home" data-toggle="tab">Điểm danh</a>
          </li>
          <li>
            <a href="#noidung" data-toggle="tab">Nội dung giảng dạy</a>
          </li>
        </ul>
    
        <div class="tab-content">
          <div class="tab-pane active" id="home">
            <br />
            <Enrollments state={this.state.lich.updated===true && this.state.lop.updated===true} data={this.state.data} on_vang={this.handleVang} loading={this.state.loading}/>
          </div>                  
          <div class="tab-pane" id="noidung">
            <br />
            <NoiDung lich={this.state.lich} onNoidung={this.handleNoiDung} />
          </div>
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
  <Lich lich={ENV.lich_id} />,
  document.getElementById('main')
);  
   