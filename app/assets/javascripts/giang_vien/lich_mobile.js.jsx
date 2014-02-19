/** @jsx React.DOM */


var DisabledEnrollment = React.createClass({
  render: function(){
    return (
      <tr class={this.props.stt % 2 == 0 ? 'danger' : 'default'}>
        <td>{this.props.stt}</td>
        <td>{this.props.enrollment.name} ({this.props.enrollment.code})</td>       
        <td>x</td>        
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
      <tr class={this.props.stt % 2 == 0 ? 'danger' : 'default'}>        
        <td>{this.props.stt}.{this.props.enrollment.name}
        <br/> (<a href={'/sinh_viens/'+ this.props.enrollment.sinh_vien_id}>{this.props.enrollment.code}</a>)</td>
        <td><button onClick={this.props.on_absent} disabled={this.props.enrollment.idle_status === "Không" || this.props.ajax.loading === true || this.props.enrollment.status === "Trễ" ? 'disabled' : ''}  class={css[this.props.enrollment.status]}>{this.props.enrollment.status}</button>
        <br/>
        <button onClick={this.props.on_plus} class="btn btn-default btn-sm" disabled={plus === 'disabled' ? 'disabled' : ''}><span class="glyphicon glyphicon-plus"></span></button>{'   '}{this.props.enrollment.so_tiet_vang}{'   '}
        <button onClick={this.props.on_minus}  class="btn btn-default btn-sm" disabled={minus === 'disabled' ? 'disabled' : ''} ><span class="glyphicon glyphicon-minus"></span></button></td>
        <td><button disabled={this.props.enrollment.idle_status === "Không" && ( ( (this.props.enrollment.so_tiet_vang === 0 && this.props.state===true) || this.props.ajax.loading === true) ) ? 'disabled' : ''} onClick={this.props.on_phep} class={phep[this.props.enrollment.phep_status]}>{this.props.enrollment.phep_status}</button></td>
        <td><button onClick={this.props.on_idle} class={idle[this.props.enrollment.idle_status]}>{this.props.enrollment.idle_status}</button></td>        
      </tr>
    );
  }
});
var Enrollments = React.createClass({  
  handleVang: function(e,s){
    var self = this;
    this.props.loading = true;
    this.forceUpdate();    
    self.props.on_vang(e,s);      
    return false;
  },  
  render: function(){      
    var self = this;
    var enrollments = this.props.data.map(function (enrollment, i) {
      if (self.props.state === false){
        return <DisabledEnrollment stt={i+1} key={enrollment.id} enrollment={enrollment} />
      } else {
        return <Enrollment state={self.props.state} stt={i+1} key={enrollment.id} enrollment={enrollment} on_absent={self.handleVang.bind(self,enrollment, 'vang')} on_plus={self.handleVang.bind(self,enrollment,'plus')} on_idle={self.handleVang.bind(self, enrollment, 'idle')} on_minus={self.handleVang.bind(self,enrollment,'minus')} on_phep={self.handleVang.bind(self,enrollment,'phep')} ajax={{loading: self.props.loading}} />;
      }      
    }); 
    return (
      <div>          
        <h4>Thông tin điểm danh:</h4>
        <div class="table-responsive">
          <table class="table table-bordered table-condensed table-striped">
            <colgroup>              
              <col style={{width: "28%"}} />            
              <col style={{width: "24%"}} />
              <col style={{width: "24%"}} />
              <col style={{width: "24%"}} />                        
            </colgroup>
            <thead><tr class="success">              
              <td>Sinh viên</td>                        
              <td>Vắng</td>                      
              <td>Phép</td>  
              <td>Bắt buộc</td></tr>           
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

var Lich = React.createClass({      
  loadEnrollmentsFromServer: function(){    
    $.ajax({
      url: "/teacher/lich/"+this.props.lich+"/attendances.json" ,
      success: function(data2) {                      
        this.setState({noidung: data2.info.lich.content,data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false});         
      }.bind(this)
    });    
  },  
  componentWillMount: function() {
    this.loadEnrollmentsFromServer();  
  },    
  getInitialState: function() {
    return {data: [], lich: {}, lop: {}, loading: false };
  },      
  getInitialState: function() {
    return {data: [], lich: {}, lop: {}, loading: false };
  },   
  handleChangeContent: function(e){
    this.setState({noidung: e.target.value});
    this.state.lich.content = this.state.noidung;
  },
  handleComplete: function(d){
    d.giang_vien = this.props.giang_vien;
    d.lop_id = this.props.lop;
    $.ajax({
            url: "/teacher/lop/" + this.props.lop + "/lich_trinh_giang_days/complete",
              type: 'POST',
              data: d,
              success: function(data2) {             
                this.setState({noidung: data2.info.lich.content, data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false});                
              }.bind(this)           
          }); 
  },       
  handleVang: function(enrollment, stat){    
    var d = {            
      stat: stat,
      lich_id: this.state.lich.id,
      enrollment: enrollment
    };    
    $.ajax({
      url: "/teacher/lich/"+this.props.lich+"/attendances",
      type: 'POST',
      data: d,
      success: function(data2) {             
        this.setState({noidung: data2.info.lich.content, data : data2.enrollments, lich: data2.info.lich, lop: data2.info.lop, loading: false});         
      }.bind(this)
    });
    return false;
  },    
  render: function(){      
    
    return (    
    <div><h4>Thông tin buổi học</h4>
            <LichSetting lich={this.state.lich} onComplete={this.handleComplete} />
            <hr/>
            <Editor lich_id={this.props.lich} />
            <hr/>
          <Enrollments state={this.state.lich.can_diem_danh===true} data={this.state.data} on_vang={this.handleVang} loading={this.state.loading}/>
          </div>
    );    
  }
});

var LichSetting = React.createClass({  
  handleComplete: function(e){
    this.props.onComplete(this.props.lich);
  },
  render: function(){      
    return (        
      <div class="table-responsive">
        <table class="table table-bordered">
          <thead><tr class="success">
            <td>Phòng</td>
            <td>Loại</td>
            <td>Số tiết</td>
            <td>Số có mặt</td>
            <td>Số vắng</td>
            <td>Giờ học</td>
            <td>Trạng thái</td>
            <td>Thao tác</td></tr>
          </thead>
          <tbody>
            <tr>
              <td>{this.props.lich.phong}</td>
              <td>{this.props.lich.type_status}</td>
              <td>{this.props.lich.so_tiet}</td>
              <td>{this.props.lich.sv_co_mat}</td>
              <td>{this.props.lich.sv_vang_mat}</td>
              <td>{this.props.lich.alias_state}</td>
              <td>{this.props.lich.alias_status}</td>
              <td>
                {this.props.lich.updated ? <div><button onClick={this.handleComplete} class="btn btn-sm btn-primary curl-top-left" title="" data-placement="left" data-toggle="tooltip" type="button" data-original-title="Nhấn vào hoàn thành để tính buổi dạy này vào khối lượng thực hiện giảng dạy">Hoàn thành</button></div> : '' }                  
              </td>                            
            </tr>
          </tbody>
        </table>
      </div>
    );
  }
});

var Editor = React.createClass({
  getInitialState: function(){
    return {edit: 0, data: ""}
  },
  loadContent: function(){
    $.ajax({
      url: '/teacher/lich_trinh_giang_days/' + this.props.lich_id + '/mobile_content',
      success: function(data){
        this.setState({edit: 0, data: data})
      }.bind(this)
    })
  },
  onEdit: function(){
    this.setState({edit: 1});
  },
  onCancel: function(){
    this.setState({edit: 0});
  },
  onUpdate: function(){
    var content = this.refs.noidung.getDOMNode().value;
    $.ajax({
      url: '/teacher/lich_trinh_giang_days/mobile_content',
      type: 'POST',
      data: {lich_id: this.props.lich_id, content: content},
      success: function(data){
        this.setState({edit: 0, data: data})
      }.bind(this)
    })
  },
  componentWillMount: function(){
    this.loadContent();
  },
  componentDidUpdate: function(){
    if (this.state.edit === 1) {
      this.refs.noidung.getDOMNode().value = this.state.data.content
    }    
  },
  render: function(){
    if (this.state.edit === 0){
      return (
        <div>
          <h4>Nội dung giảng dạy</h4>
          <span dangerouslySetInnerHTML={{__html: this.state.data.content_html }} />
          <br/>
          <button onClick={this.onEdit} class="btn btn-sm btn-success">Sửa nội dung</button>
        </div>
      )
    } else {
      return (      
        <div>
          <h4>Nội dung giảng dạy</h4>
          <textarea style={{width:"100%"}} ref="noidung" />
          <br/>
          <button onClick={this.onCancel} class="btn btn-sm btn-warning">Hủy</button>
          <button onClick={this.onUpdate} class="btn btn-sm btn-primary">Cập nhật</button>
        </div>
      )
    }    
  }
})

React.renderComponent(  
  <Lich lich={ENV.lich_id} lop={ENV.lop_id} giang_vien={ENV.giang_vien_id} />,
  document.getElementById('main')
);  
   