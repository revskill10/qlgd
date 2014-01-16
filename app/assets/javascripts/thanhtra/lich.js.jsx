/** @jsx React.DOM */


var ThanhTra = React.createClass({
  getInitialState: function(){
    return {data: []}
  },
  componentDidMount: function(){    
    $('.input-append.date').datepicker({
      format: "dd/mm/yyyy",
      startDate: "13/1/2014",
      todayBtn: "linked",
        language: "vi",
        autoClose: false,
        todayHighlight: true
    });    
  },
  handleDate: function(){
    var date = this.refs.thoi_gian.getDOMNode().value;
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days',
      type: 'POST',
      data: {date: date},
      success: function(data){
        this.setState({data: data});
      }.bind(this)
    });
  },
  render: function(){
    var x = this.state.data.map(function(d, index){
      return <ThanhTraRow data={d} stt={index+1} color={index % 2 === 0 ? 'danger' : 'warning'} />
    });
    return (
      <div>
        <div class="input-append date">
          <input ref="thoi_gian" type="text" class="span2" /><span class="add-on"><i class="icon-th"></i></span>
          <button class="btn btn-sm btn-primary" onClick={this.handleDate}>Chọn ngày</button>          
        </div>
        <div class="table-responsive">      
          <table class="table table-bordered">
            <thead>
              <tr class="success">
                <td>Stt</td><td>Giờ học</td><td>Báo lỗi</td><td>Note 1</td><td>Note 2</td><td>Note 3</td><td>Thao tác</td>
              </tr>
            </thead>
            <tbody>
              {x}
            </tbody>
          </table>
        </div>
      </div>
    );
  }
});

var ThanhTraRow = React.createClass({
  render: function(){
    return (
      <tr class={this.props.color}>
        <td>{this.props.stt}</td>
        <td>{this.props.data.info}</td>
        <td>{this.props.data.di_muon_alias}<br/>{this.props.data.ve_som_alias}<br/>{this.props.data.bo_tiet_alias}</td>
        <td>{this.props.data.note1}</td>
        <td>{this.props.data.note2}</td>
        <td>{this.props.data.note3}</td>
        <td>
          <button class="btn btn-sm btn-primary">Báo cáo</button>
        </td>
      </tr>
    );
  }
});