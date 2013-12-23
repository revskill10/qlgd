/** @jsx React.DOM */

var Enrollment = React.createClass({
  render: function() {
    return (
      <tr>
        <td>{this.props.key}</td>
        <td>{this.props.name}</td>
        <td>{this.props.code}</td>
        <td><button class="btn btn-success">{this.props.status}</button></td>
      </tr>
    );
  }
});
var EnList = React.createClass({
  render: function(){
    var enrollments = this.props.data.map(function (enrollment) {
      return <Enrollment key={enrollment.enrollment.id} name={enrollment.enrollment.name} code={enrollment.enrollment.code} status={enrollment.enrollment.status}/>;
    });    
    return (      
        <tbody>
          {enrollments}
        </tbody>      
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
    return (
      <table class="table">
        <thead>
          <td>Stt</td>
          <td>Họ tên</td>
          <td>Mã sinh viên</td>
          <td>Vắng</td>          
        </thead>
        <EnList data={this.state.data} />
      </table>
    );
  }
});
React.renderComponent(
  <Enrollments url= {"/lich/" + ENV.lich_id + "/enrollments.json"}/>,
  document.getElementById('mainapp')
);