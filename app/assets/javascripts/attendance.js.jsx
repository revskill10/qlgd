/** @jsx React.DOM */

var Enrollment = React.createClass({

  render: function() {
    var css = {"Không vắng": "btn btn-success btn-sm",
              "Vắng": "btn btn-danger btn-sm",
              "Trễ": "btn btn-warning btn-sm",
              "Không học": "btn btn-primary btn-sm"};
    return (
      
      <tr>
        <td>{this.props.key}</td>
        <td>{this.props.name}</td>
        <td>{this.props.code}</td>
        <td><button class={css[this.props.status]}>{this.props.status}</button></td>
      </tr>
    );
  }
});
var Enrollments = React.createClass({
  loadEnrollmentsFromServer: function(){
    $.ajax({
      url: this.props.url,
      success: function(data) {
        this.setState({data: data});
      }.bind(this)
    });
  },
  componentWillMount: function() {
    this.loadEnrollmentsFromServer();
  },
  getInitialState: function() {
    return {data: []};
  },
  render: function(){  
    var enrollments = this.state.data.map(function (enrollment) {
      return <Enrollment key={enrollment.id} name={enrollment.name} code={enrollment.code} status={enrollment.status}/>;
    }); 
    return (
      <div>        
        <h6>Thông tin điểm danh:</h6>
        <table class="table table-bordered table-condensed">
          <thead>
            <td>Stt</td>
            <td>Họ tên</td>
            <td>Mã sinh viên</td>
            <td>Vắng</td>          
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
  loadLichsFromServer: function(){
    $.ajax({
      url: this.props.url,
      success: function(data) {
        this.setState({data: data});
      }.bind(this)
    });
  },
  componentWillMount: function() {
    this.loadLichsFromServer();
  },
  getInitialState: function() {
    return {data: []};
  },
  render: function(){
    return (
      <div>
        <h6>Thông tin lớp học</h6>
        <table class="table table-bordered">
          <thead>
            <td>Mã lớp</td>
            <td>Tên môn học</td>
            <td>Giảng viên</td>
          </thead>
          <tbody>
            <tr><td>{this.state.data.ma_lop}</td>
            <td>{this.state.data.ten_mon_hoc}</td>
            <td>GV</td></tr>
          </tbody>
        </table>
      </div>
    );    
  }
});
var Lich = React.createClass({
  loadLichFromServer: function(){
    $.ajax({
      url: this.props.url,
      success: function(data) {
        this.setState({data: data});
      }.bind(this)
    });
  },
  componentWillMount: function() {
    this.loadLichFromServer();
  },
  getInitialState: function() {
    return {data: []};
  },
  render: function(){
    return (
      <div>
        <h6>Thông tin buổi học</h6>
        <table class="table table-bordered">
          <thead>
            <td>Phòng</td>
            <td>Thực hành</td>
            <td>Số sinh viên có mặt</td>
            <td>Số sinh viên vắng</td>
            <td>Trạng thái</td>
          </thead>
          <tbody>
            <tr>
              <td>{this.state.data.phong}</td>
              <td>{this.state.data.thuc_hanh}</td>
              <td>{this.state.data.sv_co_mat}</td>
              <td>{this.state.data.sv_vang_mat}</td>
            </tr>
          </tbody>
        </table>
      </div>
    );    
  }
});
React.renderComponent(  
  <Lop url={"/lop/" + ENV.lop_id + "/info"} />,
  document.getElementById('lop')
);
React.renderComponent(  
  <Lich url={"/lich/" + ENV.lich_id + "/info"} />,
  document.getElementById('lich')
);
React.renderComponent(  
  <Enrollments url= {"/lich/" + ENV.lich_id + "/enrollments.json"}/>,
  document.getElementById('main')
);