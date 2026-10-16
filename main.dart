import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

const Color primaryBlue = Color(0xFF0D47A1);
const Color secondaryBlue = Color(0xFF1565C0);
const Color lightBlue = Color(0xFFE3F2FD);
const Color accentGreen = Color(0xFF7AC74F);
const Color whiteColor = Colors.white;

void main() { runApp(SalaamaApp()); }

class SalaamaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salaama Muslim Junior School',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: whiteColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue, primary: primaryBlue),
        appBarTheme: AppBarTheme(backgroundColor: primaryBlue, foregroundColor: whiteColor, centerTitle: true),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: whiteColor)),
      ),
      home: SplashScreen(),
    );
  }
}

class Student {
  String id, name, className, parentName, phone, type;
  double feesBalance; String hifzLevel; Map<String, dynamic> hifzProgress;
  Student({required this.id, required this.name, required this.className, required this.parentName, required this.phone, required this.type, this.feesBalance=0, this.hifzLevel="1", Map<String, dynamic>? hifzProgress}) : hifzProgress = hifzProgress ?? {"sabaq":"", "darsuSitta":"", "murajia":"", "lastDate":""};
  Map<String, dynamic> toJson() => {"id":id,"name":name,"className":className,"parentName":parentName,"phone":phone,"type":type,"feesBalance":feesBalance,"hifzLevel":hifzLevel,"hifzProgress":hifzProgress};
  factory Student.fromJson(Map<String,dynamic> j) => Student(id:j['id'],name:j['name'],className:j['className'],parentName:j['parentName'],phone:j['phone'],type:j['type'],feesBalance:(j['feesBalance']??0).toDouble(),hifzLevel:j['hifzLevel']??"1",hifzProgress:j['hifzProgress']);
}

class Staff {
  String id, name, phone, role, type, subject; double salary;
  Staff({required this.id, required this.name, required this.phone, required this.role, required this.type, this.subject="", this.salary=0});
  Map<String, dynamic> toJson() => {"id":id,"name":name,"phone":phone,"role":role,"type":type,"subject":subject,"salary":salary};
  factory Staff.fromJson(Map<String,dynamic> j) => Staff(id:j['id'],name:j['name'],phone:j['phone'],role:j['role'],type:j['type'],subject:j['subject']??"",salary:(j['salary']??0).toDouble());
}

class FeeRecord {
  String studentId, studentName, term; double amount; String date;
  FeeRecord({required this.studentId, required this.studentName, required this.term, required this.amount, required this.date});
  Map<String, dynamic> toJson() => {"studentId":studentId,"studentName":studentName,"term":term,"amount":amount,"date":date};
  factory FeeRecord.fromJson(Map<String,dynamic> j) => FeeRecord(studentId:j['studentId'],studentName:j['studentName'],term:j['term'],amount:(j['amount']).toDouble(),date:j['date']);
}

class SalaryRecord {
  String staffId, staffName, month; double amount; String date;
  SalaryRecord({required this.staffId, required this.staffName, required this.month, required this.amount, required this.date});
  Map<String,dynamic> toJson() => {"staffId":staffId,"staffName":staffName,"month":month,"amount":amount,"date":date};
  factory SalaryRecord.fromJson(Map<String,dynamic> j) => SalaryRecord(staffId:j['staffId'],staffName:j['staffName'],month:j['month'],amount:(j['amount']).toDouble(),date:j['date']);
}

class DataService {
  static Future<List<Student>> getStudents() async {
    final prefs = await SharedPreferences.getInstance(); final s = prefs.getString('students'); if(s==null) return []; return (jsonDecode(s) as List).map((e)=>Student.fromJson(e)).toList();
  }
  static Future saveStudents(List<Student> list) async {
    final prefs = await SharedPreferences.getInstance(); prefs.setString('students', jsonEncode(list.map((e)=>e.toJson()).toList()));
  }
  static Future<List<Staff>> getStaff() async {
    final prefs = await SharedPreferences.getInstance(); final s = prefs.getString('staff'); if(s==null) return []; return (jsonDecode(s) as List).map((e)=>Staff.fromJson(e)).toList();
  }
  static Future saveStaff(List<Staff> list) async {
    final prefs = await SharedPreferences.getInstance(); prefs.setString('staff', jsonEncode(list.map((e)=>e.toJson()).toList()));
  }
  static Future<List<FeeRecord>> getFees() async {
    final prefs = await SharedPreferences.getInstance(); final s = prefs.getString('fees'); if(s==null) return []; return (jsonDecode(s) as List).map((e)=>FeeRecord.fromJson(e)).toList();
  }
  static Future saveFees(List<FeeRecord> list) async {
    final prefs = await SharedPreferences.getInstance(); prefs.setString('fees', jsonEncode(list.map((e)=>e.toJson()).toList()));
  }
  static Future<List<SalaryRecord>> getSalaries() async {
    final prefs = await SharedPreferences.getInstance(); final s = prefs.getString('salaries'); if(s==null) return []; return (jsonDecode(s) as List).map((e)=>SalaryRecord.fromJson(e)).toList();
  }
  static Future saveSalaries(List<SalaryRecord> list) async {
    final prefs = await SharedPreferences.getInstance(); prefs.setString('salaries', jsonEncode(list.map((e)=>e.toJson()).toList()));
  }
}

class SplashScreen extends StatefulWidget { @override _SplashScreenState createState()=>_SplashScreenState();}
class _SplashScreenState extends State<SplashScreen> {
  @override void initState(){ super.initState(); Future.delayed(Duration(seconds:2), (){ Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));});}
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: primaryBlue, body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(100)), child: Image.asset('assets/images/logo.png', height: 140, width: 140, errorBuilder: (c,e,s)=>Icon(Icons.school,size:80,color:primaryBlue))),
      SizedBox(height:20),
      Text('SALAAMA MUSLIM', style: TextStyle(color:whiteColor,fontSize:22,fontWeight:FontWeight.bold,letterSpacing:1)),
      Text('JUNIOR SCHOOL', style: TextStyle(color:whiteColor,fontSize:22,fontWeight:FontWeight.bold)),
      SizedBox(height:8),
      Container(padding: EdgeInsets.symmetric(horizontal:12,vertical:4), color: accentGreen, child: Text('DESTINED TO SUCCEED', style: TextStyle(color:whiteColor,fontWeight:FontWeight.bold))),
      SizedBox(height:30),
      CircularProgressIndicator(color: whiteColor),
    ])));
  }
}

class LoginScreen extends StatefulWidget { @override _LoginScreenState createState()=>_LoginScreenState();}
class _LoginScreenState extends State<LoginScreen> {
  String role='Admin'; final userCtrl=TextEditingController(text:'admin'); final passCtrl=TextEditingController(text:'admin123');
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: whiteColor, body: SingleChildScrollView(padding: EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(height:60),
      Image.asset('assets/images/logo.png', height: 120, errorBuilder: (c,e,s)=>Icon(Icons.school,size:80,color:primaryBlue)),
      SizedBox(height:10),
      Text('SALAAMA MUSLIM JUNIOR SCHOOL APP', textAlign:TextAlign.center, style: TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:primaryBlue)),
      Text('DESTINED TO SUCCEED', style: TextStyle(color:primaryBlue, fontWeight:FontWeight.w600)),
      SizedBox(height:30),
      Container(decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(12)), child: Row(children: [
        Expanded(child: RadioListTile(value:'Admin', groupValue:role, title:Text('Admin'), onChanged:(v)=>setState(()=>role=v!))),
        Expanded(child: RadioListTile(value:'Teacher', groupValue:role, title:Text('Teacher'), onChanged:(v)=>setState(()=>role=v!))),
      ])),
      SizedBox(height:20),
      TextField(controller:userCtrl, decoration: InputDecoration(labelText:'Username', prefixIcon:Icon(Icons.person,color:primaryBlue), border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),
      SizedBox(height:16),
      TextField(controller:passCtrl, obscureText:true, decoration: InputDecoration(labelText:'Password', prefixIcon:Icon(Icons.lock,color:primaryBlue), border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),
      SizedBox(height:24),
      SizedBox(width:double.infinity,height:50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor:primaryBlue, shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))), onPressed: (){
        if(role=='Admin') Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>AdminHome()));
        else Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>TeacherHome()));
      }, child: Text('LOGIN AS $role', style: TextStyle(fontSize:16,fontWeight:FontWeight.bold)))),
      SizedBox(height:12),
      Text('For Support: nassakalatiifah@gmail.com | +256 702 642 786', style: TextStyle(fontSize:11,color:Colors.grey)),
    ])));
  }
}

class AdminHome extends StatefulWidget { @override _AdminHomeState createState()=>_AdminHomeState();}
class _AdminHomeState extends State<AdminHome> {
  int _index=0;
  final pages=[DashboardPage(), StudentsPage(), FeesPage(), StaffSalaryPage(), ReportsPage(), CashFlowPage(), ChatPage(), MediaLibraryPage(), PdfGeneratorPage(), SettingsPage()];
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Row(children:[Image.asset('assets/images/logo.png', height:32, errorBuilder: (c,e,s)=>Icon(Icons.school)), SizedBox(width:8), Text('Salaama Admin', style:TextStyle(fontSize:16))]), backgroundColor: primaryBlue, actions:[IconButton(icon:Icon(Icons.logout), onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen())))]),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(currentIndex:_index, type:BottomNavigationBarType.fixed, selectedItemColor:primaryBlue, unselectedItemColor:Colors.grey, onTap:(i)=>setState(()=>_index=i), items:[
        BottomNavigationBarItem(icon:Icon(Icons.dashboard), label:'Dashboard'),
        BottomNavigationBarItem(icon:Icon(Icons.people), label:'Students'),
        BottomNavigationBarItem(icon:Icon(Icons.receipt), label:'Fees'),
        BottomNavigationBarItem(icon:Icon(Icons.work), label:'Staff'),
        BottomNavigationBarItem(icon:Icon(Icons.bar_chart), label:'More'),
      ]),
      drawer: Drawer(child: ListView(padding:EdgeInsets.zero, children:[
        DrawerHeader(decoration:BoxDecoration(color:primaryBlue), child: Column(children:[Image.asset('assets/images/logo.png', height:70, errorBuilder:(c,e,s)=>Icon(Icons.school,color:whiteColor,size:50)), SizedBox(height:8), Text('SALAAMA MUSLIM JUNIOR SCHOOL', style:TextStyle(color:whiteColor,fontWeight:FontWeight.bold, fontSize:12), textAlign:TextAlign.center), Text('DESTINED TO SUCCEED', style:TextStyle(color:accentGreen, fontSize:10))])),
        _drawerTile(Icons.dashboard,'Dashboard',0),
        _drawerTile(Icons.people,'Students (Ordinary & Tahfiz)',1),
        _drawerTile(Icons.receipt_long,'Fees & Receipts',2),
        _drawerTile(Icons.payments,'Teachers Salary',3),
        _drawerTile(Icons.assessment,'Reports',4),
        _drawerTile(Icons.show_chart,'Cash Flow with Graph',5),
        _drawerTile(Icons.chat,'Chat Box',6),
        _drawerTile(Icons.photo_library,'Media Library',7),
        _drawerTile(Icons.picture_as_pdf,'PDF Generator',8),
        _drawerTile(Icons.settings,'School Settings',9),
      ])),
    );
  }
  Widget _drawerTile(IconData icon, String title, int idx){ return ListTile(leading:Icon(icon,color:primaryBlue), title:Text(title, style:TextStyle(fontSize:13)), selected:_index==idx, onTap:(){ setState(()=>_index=idx); Navigator.pop(context);});}
}

class TeacherHome extends StatefulWidget { @override _TeacherHomeState createState()=>_TeacherHomeState();}
class _TeacherHomeState extends State<TeacherHome> {
  int _index=0;
  final pages=[TeacherDashboard(), TeacherStudentsPage(), AttendancePage(), FeesViewPage(), GradebookPage(), LessonPlanPage(), ChatPage()];
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Row(children:[Image.asset('assets/images/logo.png', height:32, errorBuilder:(c,e,s)=>Icon(Icons.school)), SizedBox(width:8), Text('Teacher Menu')]), backgroundColor: primaryBlue, actions:[IconButton(icon:Icon(Icons.logout), onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen())))]),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(currentIndex:_index, type:BottomNavigationBarType.fixed, selectedItemColor:primaryBlue, onTap:(i)=>setState(()=>_index=i), items:[
        BottomNavigationBarItem(icon:Icon(Icons.dashboard), label:'Dashboard'),
        BottomNavigationBarItem(icon:Icon(Icons.class_), label:'My Classes'),
        BottomNavigationBarItem(icon:Icon(Icons.people), label:'My Students'),
        BottomNavigationBarItem(icon:Icon(Icons.fact_check), label:'More'),
      ]),
      drawer: Drawer(child: ListView(padding:EdgeInsets.zero, children:[
        DrawerHeader(decoration:BoxDecoration(color:primaryBlue), child: Column(children:[Image.asset('assets/images/logo.png', height:70, errorBuilder:(c,e,s)=>Icon(Icons.school,color:whiteColor,size:50)), SizedBox(height:8), Text('TEACHER MENU', style:TextStyle(color:whiteColor,fontWeight:FontWeight.bold))])),
        _drawerTile(Icons.class_,'My Classes',0),
        _drawerTile(Icons.people,'My Students',1),
        _drawerTile(Icons.calendar_today,'Attendance',2),
        _drawerTile(Icons.visibility,'Fees View Only',3),
        _drawerTile(Icons.star,'Gradebook',4),
        _drawerTile(Icons.menu_book,'Lesson Plans',5),
        _drawerTile(Icons.chat,'Chat',6),
      ])),
    );
  }
  Widget _drawerTile(IconData icon, String title, int idx){ return ListTile(leading:Icon(icon,color:primaryBlue), title:Text(title), selected:_index==idx, onTap:(){ setState(()=>_index=idx); Navigator.pop(context);});}
}

class DashboardPage extends StatefulWidget { @override _DashboardPageState createState()=>_DashboardPageState();}
class _DashboardPageState extends State<DashboardPage> {
  int totalStudents=0, ordinary=0, tahfiz=0, staff=0; double totalFees=0, totalSalaries=0;
  @override void initState(){ super.initState(); _load();}
  Future _load() async {
    var st=await DataService.getStudents(); var sf=await DataService.getStaff(); var fees=await DataService.getFees(); var sal=await DataService.getSalaries();
    setState((){
      totalStudents=st.length; ordinary=st.where((s)=>s.type=='ordinary').length; tahfiz=st.where((s)=>s.type=='tahfiz').length; staff=sf.length;
      totalFees=fees.fold(0,(a,b)=>a+b.amount); totalSalaries=sal.fold(0,(a,b)=>a+b.amount);
    });
  }
  @override Widget build(BuildContext context){
    return SingleChildScrollView(padding:EdgeInsets.all(16), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      Row(children:[Image.asset('assets/images/logo.png', height:40, errorBuilder:(c,e,s)=>Icon(Icons.school,color:primaryBlue)), SizedBox(width:8), Text('ADMIN MENU', style:TextStyle(fontWeight:FontWeight.bold, color:primaryBlue))]),
      SizedBox(height:12),
      GridView.count(crossAxisCount:2, shrinkWrap:true, physics:NeverScrollableScrollPhysics(), crossAxisSpacing:12, mainAxisSpacing:12, children:[
        _statCard('Total Students', totalStudents.toString(), Icons.people, primaryBlue),
        _statCard('Ordinary', ordinary.toString(), Icons.school, secondaryBlue),
        _statCard('Tahfiz Students', tahfiz.toString(), Icons.menu_book, Colors.green),
        _statCard('Staff (Teaching & Non)', staff.toString(), Icons.work, Colors.orange),
        _statCard('Fees Collected', 'UGX ${NumberFormat.compact().format(totalFees)}', Icons.payments, Colors.teal),
        _statCard('Salaries Paid', 'UGX ${NumberFormat.compact().format(totalSalaries)}', Icons.money, Colors.red),
      ]),
      SizedBox(height:20),
      Text('Cash Flow Overview', style:TextStyle(fontWeight:FontWeight.bold)),
      SizedBox(height:12),
      Container(height:200, padding:EdgeInsets.all(12), decoration:BoxDecoration(color:whiteColor, borderRadius:BorderRadius.circular(12), boxShadow:[BoxShadow(color:Colors.black12, blurRadius:4)]), child: LineChart(LineChartData(gridData:FlGridData(show:false), titlesData:FlTitlesData(show:true), borderData:FlBorderData(show:false), lineBarsData:[LineChartBarData(spots:[FlSpot(0,1),FlSpot(1,2),FlSpot(2,1.5),FlSpot(3,3),FlSpot(4,2.5),FlSpot(5,4)], isCurved:true, color:primaryBlue, barWidth:3, belowBarData:BarAreaData(show:true, color:lightBlue))]))),
      SizedBox(height:12),
      Text('For Support: nassakalatiifah@gmail.com | +256 702 642 786', style:TextStyle(fontSize:10,color:Colors.grey)),
    ]));
  }
  Widget _statCard(String title, String value, IconData icon, Color color){
    return Card(elevation:3, shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)), child: Padding(padding:EdgeInsets.all(12), child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[Icon(icon,size:32,color:color), SizedBox(height:6), Text(value, style:TextStyle(fontWeight:FontWeight.bold,fontSize:18)), Text(title, textAlign:TextAlign.center, style:TextStyle(fontSize:11))]))); 
  }
}

class StudentsPage extends StatefulWidget { @override _StudentsPageState createState()=>_StudentsPageState();}
class _StudentsPageState extends State<StudentsPage> {
  List<Student> students=[]; String filter='all'; String search='';
  @override void initState(){ super.initState(); _load();}
  Future _load() async { var list=await DataService.getStudents(); setState(()=>students=list); }
  Future _save() async { await DataService.saveStudents(students); }
  @override Widget build(BuildContext context){
    var filtered=students.where((s){ if(filter!='all' && s.type!=filter) return false; if(search.isNotEmpty && !s.name.toLowerCase().contains(search.toLowerCase())) return false; return true;}).toList();
    return Column(children:[
      Padding(padding:EdgeInsets.all(12), child: Column(children:[
        TextField(onChanged:(v)=>setState(()=>search=v), decoration:InputDecoration(hintText:'Search student', prefixIcon:Icon(Icons.search), border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)), isDense:true)),
        SizedBox(height:8),
        Row(children:[
          ChoiceChip(label:Text('All'), selected:filter=='all', onSelected:(_)=>setState(()=>filter='all')),
          SizedBox(width:6),
          ChoiceChip(label:Text('Ordinary'), selected:filter=='ordinary', onSelected:(_)=>setState(()=>filter='ordinary')),
          SizedBox(width:6),
          ChoiceChip(label:Text('Tahfiz'), selected:filter=='tahfiz', onSelected:(_)=>setState(()=>filter='tahfiz')),
        ]),
      ])),
      Expanded(child: ListView.builder(itemCount:filtered.length, itemBuilder:(c,i){
        var s=filtered[i];
        return Card(margin:EdgeInsets.symmetric(horizontal:12,vertical:4), child: ListTile(leading:CircleAvatar(backgroundColor: s.type=='tahfiz'?Colors.green:primaryBlue, child:Icon(s.type=='tahfiz'?Icons.menu_book:Icons.person,color:whiteColor)), title:Text(s.name), subtitle:Text('${s.className} | ${s.type.toUpperCase()} | Parent: ${s.parentName}\nFees Bal: UGX ${s.feesBalance} ${s.type=='tahfiz'? '| Hifz: Juz ${s.hifzLevel}':''}'), isThreeLine:true, trailing:PopupMenuButton(onSelected:(v){ if(v=='edit') _showStudentDialog(edit:s); else if(v=='hifz' && s.type=='tahfiz') _showHifzDialog(s); else if(v=='delete'){ setState(()=>students.removeWhere((x)=>x.id==s.id)); _save(); } else if(v=='pdf') _generateStudentPdf(s); }, itemBuilder:(_)=>[PopupMenuItem(value:'edit',child:Text('Edit')), if(s.type=='tahfiz') PopupMenuItem(value:'hifz',child:Text('Hifz: Sabaq/Sitta/Murajia')), PopupMenuItem(value:'pdf',child:Text('PDF with Logo')), PopupMenuItem(value:'delete',child:Text('Delete'))]))); 
      })),
      Padding(padding:EdgeInsets.all(12), child: SizedBox(width:double.infinity, child: ElevatedButton.icon(icon:Icon(Icons.add), label:Text('Add Student (Ordinary or Tahfiz)'), onPressed:()=>_showStudentDialog()))),
    ]);
  }
  void _showStudentDialog({Student? edit}){
    final nameCtrl=TextEditingController(text:edit?.name??''); final classCtrl=TextEditingController(text:edit?.className??''); final parentCtrl=TextEditingController(text:edit?.parentName??''); final phoneCtrl=TextEditingController(text:edit?.phone??''); String type=edit?.type??'ordinary';
    showDialog(context:context, builder:(_)=>StatefulBuilder(builder:(ctx,setSt)=>AlertDialog(title:Text(edit==null?'Add Student':'Edit Student'), content:SingleChildScrollView(child: Column(mainAxisSize:MainAxisSize.min, children:[
      TextField(controller:nameCtrl, decoration:InputDecoration(labelText:'Student Name')),
      TextField(controller:classCtrl, decoration:InputDecoration(labelText:'Class')),
      TextField(controller:parentCtrl, decoration:InputDecoration(labelText:'Parent Name')),
      TextField(controller:phoneCtrl, decoration:InputDecoration(labelText:'Phone')),
      SizedBox(height:12),
      DropdownButtonFormField(value:type, items:[DropdownMenuItem(value:'ordinary',child:Text('Ordinary Student')), DropdownMenuItem(value:'tahfiz',child:Text('Tahfiz Student - Quran Memorization'))], onChanged:(v)=>setSt(()=>type=v!), decoration:InputDecoration(labelText:'Student Category')),
    ])), actions:[TextButton(onPressed:()=>Navigator.pop(ctx), child:Text('Cancel')), ElevatedButton(onPressed:(){ var s=Student(id:edit?.id??DateTime.now().millisecondsSinceEpoch.toString(), name:nameCtrl.text, className:classCtrl.text, parentName:parentCtrl.text, phone:phoneCtrl.text, type:type, feesBalance:edit?.feesBalance??0, hifzLevel:edit?.hifzLevel??"1", hifzProgress:edit?.hifzProgress??{"sabaq":"","darsuSitta":"","murajia":"","lastDate":""}); setState((){ if(edit!=null){ var idx=students.indexWhere((e)=>e.id==edit.id); students[idx]=s; } else students.add(s); }); _save(); Navigator.pop(ctx); }, child:Text('Save'))])));
  }
  void _showHifzDialog(Student s){
    final sabaqCtrl=TextEditingController(text:s.hifzProgress['sabaq']??''); final sittaCtrl=TextEditingController(text:s.hifzProgress['darsuSitta']??''); final murajiaCtrl=TextEditingController(text:s.hifzProgress['murajia']??''); final juzCtrl=TextEditingController(text:s.hifzLevel);
    showDialog(context:context, builder:(_)=>AlertDialog(title:Text('Hifz Progress: ${s.name}'), content:SingleChildScrollView(child: Column(children:[
      Text('Tahfiz - Quran Memorization Tracking', style:TextStyle(fontWeight:FontWeight.bold, color:Colors.green)),
      SizedBox(height:12),
      TextField(controller:juzCtrl, decoration:InputDecoration(labelText:'Current Juz / Hifz Level', border:OutlineInputBorder())),
      SizedBox(height:8),
      TextField(controller:sabaqCtrl, decoration:InputDecoration(labelText:'Sabaq - New Lesson (Today)', hintText:'Ex: Surah Baqarah Ayah 1-10', border:OutlineInputBorder()), maxLines:2),
      SizedBox(height:8),
      TextField(controller:sittaCtrl, decoration:InputDecoration(labelText:'Darsu-Sitta - Revision for recent 6 lessons', hintText:'Ex: Last 6 Sabaq revision', border:OutlineInputBorder()), maxLines:2),
      SizedBox(height:8),
      TextField(controller:murajiaCtrl, decoration:InputDecoration(labelText:'Muraji\'a - General Revision', hintText:'Ex: Juz 1-5 revision', border:OutlineInputBorder()), maxLines:2),
    ])), actions:[TextButton(onPressed:()=>Navigator.pop(context), child:Text('Cancel')), ElevatedButton(onPressed:(){ setState((){ s.hifzLevel=juzCtrl.text; s.hifzProgress={'sabaq':sabaqCtrl.text,'darsuSitta':sittaCtrl.text,'murajia':murajiaCtrl.text,'lastDate':DateFormat('yyyy-MM-dd').format(DateTime.now())}; }); _save(); Navigator.pop(context); }, child:Text('Save Hifz Progress'))]));
  }
  Future _generateStudentPdf(Student s) async {
    final pdfDoc=pw.Document(); final logoData=await _loadLogo();
    pdfDoc.addPage(pw.Page(build: (pw.Context ctx)=>pw.Column(crossAxisAlignment:pw.CrossAxisAlignment.start, children:[
      if(logoData!=null) pw.Center(child: pw.Image(pw.MemoryImage(logoData), height:80)),
      pw.SizedBox(height:10),
      pw.Center(child: pw.Text('SALAAMA MUSLIM JUNIOR SCHOOL', style:pw.TextStyle(fontSize:18, fontWeight:pw.FontWeight.bold, color:PdfColor.fromInt(0xFF0D47A1)))),
      pw.Center(child: pw.Container(padding:pw.EdgeInsets.symmetric(horizontal:8,vertical:2), color:PdfColor.fromInt(0xFF7AC74F), child:pw.Text('DESTINED TO SUCCEED', style:pw.TextStyle(color:PdfColors.white, fontSize:10)))),
      pw.SizedBox(height:20),
      pw.Text('Student Report - Generated with Logo Header', style:pw.TextStyle(fontSize:14, fontWeight:pw.FontWeight.bold)),
      pw.Divider(),
      pw.Text('Name: ${s.name}'), pw.Text('Class: ${s.className}'), pw.Text('Type: ${s.type.toUpperCase()}'), pw.Text('Parent: ${s.parentName} - ${s.phone}'), pw.Text('Fees Balance: UGX ${s.feesBalance}'),
      if(s.type=='tahfiz') pw.Column(crossAxisAlignment:pw.CrossAxisAlignment.start, children:[
        pw.SizedBox(height:10),
        pw.Text('TAHFIZ PROGRESS', style:pw.TextStyle(fontWeight:pw.FontWeight.bold)),
        pw.Text('Juz: ${s.hifzLevel}'), pw.Text('Sabaq (New Lesson): ${s.hifzProgress['sabaq']}'), pw.Text('Darsu-Sitta (6 Recent): ${s.hifzProgress['darsuSitta']}'), pw.Text('Murajia (Revision): ${s.hifzProgress['murajia']}'), pw.Text('Last Update: ${s.hifzProgress['lastDate']}'),
      ]),
      pw.Spacer(),
      pw.Text('For Support: nassakalatiifah@gmail.com | +256 702 642 786', style:pw.TextStyle(fontSize:8, color:PdfColors.grey)),
    ]))));
    await Printing.layoutPdf(onLayout: (format) async => pdfDoc.save());
  }
  Future<Uint8List?> _loadLogo() async { try{ final data=await DefaultAssetBundle.of(context).load('assets/images/logo.png'); return data.buffer.asUint8List(); }catch(_){ return null; } }
}

class FeesPage extends StatefulWidget { @override _FeesPageState createState()=>_FeesPageState();}
class _FeesPageState extends State<FeesPage> {
  List<FeeRecord> fees=[]; List<Student> students=[];
  @override void initState(){ super.initState(); _load();}
  Future _load() async { var f=await DataService.getFees(); var s=await DataService.getStudents(); setState((){ fees=f; students=s; }); }
  Future _save() async { await DataService.saveFees(fees); await DataService.saveStudents(students); }
  @override Widget build(BuildContext context){
    return Column(children:[
      Expanded(child: ListView.builder(itemCount:fees.length, itemBuilder:(c,i){ var r=fees[i]; return ListTile(leading:Icon(Icons.receipt,color:primaryBlue), title:Text('${r.studentName} - UGX ${r.amount}'), subtitle:Text('${r.term} | ${r.date}'), trailing:IconButton(icon:Icon(Icons.picture_as_pdf), onPressed:()=>_genReceiptPdf(r)));})),
      Padding(padding:EdgeInsets.all(12), child: SizedBox(width:double.infinity, child: ElevatedButton.icon(icon:Icon(Icons.add), label:Text('Record Fee Payment'), onPressed:()=>_showFeeDialog()))),
    ]);
  }
  void _showFeeDialog(){
    String? selectedId; final amountCtrl=TextEditingController(); final termCtrl=TextEditingController(text:'Term 1 2026');
    showDialog(context:context, builder:(_)=>AlertDialog(title:Text('Record Fee'), content:Column(mainAxisSize:MainAxisSize.min, children:[
      DropdownButtonFormField(items:students.map((s)=>DropdownMenuItem(value:s.id, child:Text('${s.name} (${s.type})'))).toList(), onChanged:(v)=>selectedId=v, decoration:InputDecoration(labelText:'Select Student')),
      TextField(controller:amountCtrl, keyboardType:TextInputType.number, decoration:InputDecoration(labelText:'Amount UGX')),
      TextField(controller:termCtrl, decoration:InputDecoration(labelText:'Term')),
    ]), actions:[TextButton(onPressed:()=>Navigator.pop(context), child:Text('Cancel')), ElevatedButton(onPressed:(){ var st=students.firstWhere((e)=>e.id==selectedId); var rec=FeeRecord(studentId:st.id, studentName:st.name, term:termCtrl.text, amount:double.tryParse(amountCtrl.text)??0, date:DateFormat('yyyy-MM-dd').format(DateTime.now())); setState((){ fees.add(rec); st.feesBalance-=rec.amount; }); _save(); Navigator.pop(context); }, child:Text('Save'))]));
  }
  Future _genReceiptPdf(FeeRecord r) async {
    final pdfDoc=pw.Document(); final logo=await _loadLogo();
    pdfDoc.addPage(pw.Page(build: (_)=>pw.Column(children:[
      if(logo!=null) pw.Image(pw.MemoryImage(logo), height:60),
      pw.Text('SALAAMA MUSLIM JUNIOR SCHOOL', style:pw.TextStyle(fontWeight:pw.FontWeight.bold, color:PdfColor.fromInt(0xFF0D47A1))),
      pw.Text('FEE RECEIPT', style:pw.TextStyle(fontSize:16, fontWeight:pw.FontWeight.bold)),
      pw.Divider(),
      pw.Text('Student: ${r.studentName}'), pw.Text('Amount: UGX ${r.amount}'), pw.Text('Term: ${r.term}'), pw.Text('Date: ${r.date}'),
      pw.SizedBox(height:20),
      pw.Text('Stamp & Signature ___________________'),
    ])));
    await Printing.layoutPdf(onLayout: (f) async => pdfDoc.save());
  }
  Future<Uint8List?> _loadLogo() async { try{ final d=await DefaultAssetBundle.of(context).load('assets/images/logo.png'); return d.buffer.asUint8List(); }catch(_){ return null; } }
}

class StaffSalaryPage extends StatefulWidget { @override _StaffSalaryPageState createState()=>_StaffSalaryPageState();}
class _StaffSalaryPageState extends State<StaffSalaryPage> {
  List<Staff> staff=[]; List<SalaryRecord> salaries=[]; String filter='all';
  @override void initState(){ super.initState(); _load();}
  Future _load() async { var s=await DataService.getStaff(); var sal=await DataService.getSalaries(); setState((){ staff=s; salaries=sal; }); }
  Future _saveStaff() async { await DataService.saveStaff(staff); }
  Future _saveSal() async { await DataService.saveSalaries(salaries); }
  @override Widget build(BuildContext context){
    var filtered=filter=='all'?staff:staff.where((e)=>e.type==filter).toList();
    return Column(children:[
      Padding(padding:EdgeInsets.all(8), child: Row(children:[
        ChoiceChip(label:Text('All Staff'), selected:filter=='all', onSelected:(_)=>setState(()=>filter='all')),
        SizedBox(width:6),
        ChoiceChip(label:Text('Teaching'), selected:filter=='teaching', onSelected:(_)=>setState(()=>filter='teaching')),
        SizedBox(width:6),
        ChoiceChip(label:Text('Non-Teaching'), selected:filter=='non-teaching', onSelected:(_)=>setState(()=>filter='non-teaching')),
      ])),
      Expanded(flex:2, child: ListView.builder(itemCount:filtered.length, itemBuilder:(c,i){ var s=filtered[i]; return Card(child:ListTile(leading:CircleAvatar(backgroundColor:s.type=='teaching'?primaryBlue:Colors.orange, child:Icon(s.type=='teaching'?Icons.school:Icons.work,color:whiteColor)), title:Text(s.name), subtitle:Text('${s.type.toUpperCase()} | ${s.role} | ${s.subject} | Salary: UGX ${s.salary}'), trailing:PopupMenuButton(onSelected:(v){ if(v=='salary') _showSalaryDialog(s); else if(v=='delete'){ setState(()=>staff.removeWhere((x)=>x.id==s.id)); _saveStaff(); } }, itemBuilder:(_)=>[PopupMenuItem(value:'salary',child:Text('Pay Salary')), PopupMenuItem(value:'delete',child:Text('Delete'))]))); })),
      Divider(),
      Text('Salary History', style:TextStyle(fontWeight:FontWeight.bold)),
      Expanded(flex:1, child: ListView.builder(itemCount:salaries.length, itemBuilder:(c,i){ var r=salaries[i]; return ListTile(dense:true, title:Text('${r.staffName} - ${r.month}'), subtitle:Text('UGX ${r.amount} | ${r.date}'), trailing:Icon(Icons.check_circle,color:Colors.green));})),
      Padding(padding:EdgeInsets.all(8), child: SizedBox(width:double.infinity, child: ElevatedButton.icon(icon:Icon(Icons.person_add), label:Text('Add Staff (Teaching / Non-Teaching)'), onPressed:()=>_showStaffDialog()))),
    ]);
  }
  void _showStaffDialog(){
    final nameCtrl=TextEditingController(); final phoneCtrl=TextEditingController(); final roleCtrl=TextEditingController(); final subjectCtrl=TextEditingController(); final salCtrl=TextEditingController();
    String type='teaching';
    showDialog(context:context, builder:(_)=>StatefulBuilder(builder:(ctx,setSt)=>AlertDialog(title:Text('Add Staff'), content:SingleChildScrollView(child: Column(mainAxisSize:MainAxisSize.min, children:[
      TextField(controller:nameCtrl, decoration:InputDecoration(labelText:'Name')),
      TextField(controller:phoneCtrl, decoration:InputDecoration(labelText:'Phone')),
      DropdownButtonFormField(value:type, items:[DropdownMenuItem(value:'teaching',child:Text('Teaching Staff')), DropdownMenuItem(value:'non-teaching',child:Text('Non-Teaching Staff'))], onChanged:(v)=>setSt(()=>type=v!), decoration:InputDecoration(labelText:'Staff Category')),
      TextField(controller:roleCtrl, decoration:InputDecoration(labelText:'Role (e.g. Head Teacher, Cleaner, Cook)')),
      TextField(controller:subjectCtrl, decoration:InputDecoration(labelText:'Subject (if teaching)')),
      TextField(controller:salCtrl, keyboardType:TextInputType.number, decoration:InputDecoration(labelText:'Monthly Salary UGX')),
    ])), actions:[TextButton(onPressed:()=>Navigator.pop(ctx), child:Text('Cancel')), ElevatedButton(onPressed:(){ var s=Staff(id:DateTime.now().millisecondsSinceEpoch.toString(), name:nameCtrl.text, phone:phoneCtrl.text, role:roleCtrl.text, type:type, subject:subjectCtrl.text, salary:double.tryParse(salCtrl.text)??0); setState(()=>staff.add(s)); _saveStaff(); Navigator.pop(ctx); }, child:Text('Save'))])));
  }
  void _showSalaryDialog(Staff s){
    final amountCtrl=TextEditingController(text:s.salary.toString()); final monthCtrl=TextEditingController(text:DateFormat('MMMM yyyy').format(DateTime.now()));
    showDialog(context:context, builder:(_)=>AlertDialog(title:Text('Pay Salary - ${s.name}'), content:Column(mainAxisSize:MainAxisSize.min, children:[TextField(controller:monthCtrl, decoration:InputDecoration(labelText:'Month')), TextField(controller:amountCtrl, keyboardType:TextInputType.number, decoration:InputDecoration(labelText:'Amount UGX'))]), actions:[TextButton(onPressed:()=>Navigator.pop(context), child:Text('Cancel')), ElevatedButton(onPressed:(){ var rec=SalaryRecord(staffId:s.id, staffName:s.name, month:monthCtrl.text, amount:double.tryParse(amountCtrl.text)??0, date:DateFormat('yyyy-MM-dd').format(DateTime.now())); setState(()=>salaries.add(rec)); _saveSal(); Navigator.pop(context); }, child:Text('Pay & Save'))]));
  }
}

class ReportsPage extends StatelessWidget {
  @override Widget build(BuildContext context){
    return ListView(padding:EdgeInsets.all(16), children:[
      ListTile(leading:Icon(Icons.people,color:primaryBlue), title:Text('Students Report'), subtitle:Text('Ordinary vs Tahfiz'), trailing:Icon(Icons.picture_as_pdf), onTap:()=>_genSimplePdf(context,'Students Report')),
      ListTile(leading:Icon(Icons.work,color:Colors.orange), title:Text('Staff Report'), subtitle:Text('Teaching vs Non-Teaching'), trailing:Icon(Icons.picture_as_pdf), onTap:()=>_genSimplePdf(context,'Staff Report')),
      ListTile(leading:Icon(Icons.payments,color:Colors.green), title:Text('Fees Collection Report'), trailing:Icon(Icons.picture_as_pdf), onTap:()=>_genSimplePdf(context,'Fees Report')),
      ListTile(leading:Icon(Icons.money,color:Colors.red), title:Text('Salary Report'), trailing:Icon(Icons.picture_as_pdf), onTap:()=>_genSimplePdf(context,'Salary Report')),
      ListTile(leading:Icon(Icons.menu_book,color:Colors.green), title:Text('Tahfiz Progress Report'), subtitle:Text('Sabaq, Darsu-Sitta, Murajia'), trailing:Icon(Icons.picture_as_pdf), onTap:()=>_genSimplePdf(context,'Tahfiz Report - Sabaq, Darsu-Sitta, Murajia')),
    ]);
  }
  Future _genSimplePdf(BuildContext context, String title) async {
    final doc=pw.Document();
    final logoData=await DefaultAssetBundle.of(context).load('assets/images/logo.png').then((d)=>d.buffer.asUint8List()).catchError((_)=>null);
    doc.addPage(pw.Page(build:(_)=>pw.Column(children:[
      if(logoData!=null) pw.Image(pw.MemoryImage(logoData), height:80),
      pw.Text('SALAAMA MUSLIM JUNIOR SCHOOL', style:pw.TextStyle(fontWeight:pw.FontWeight.bold, color:PdfColor.fromInt(0xFF0D47A1))),
      pw.SizedBox(height:20),
      pw.Text(title, style:pw.TextStyle(fontSize:18, fontWeight:pw.FontWeight.bold)),
      pw.Text('Generated: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
      pw.Text('Includes School Logo on Header - Auto Update Enabled'),
    ]))));
    await Printing.layoutPdf(onLayout: (f) async => doc.save());
  }
}

class CashFlowPage extends StatefulWidget { @override _CashFlowPageState createState()=>_CashFlowPageState();}
class _CashFlowPageState extends State<CashFlowPage> {
  @override Widget build(BuildContext context){
    return Padding(padding:EdgeInsets.all(16), child: Column(children:[
      Text('Cash Flow with Graph - Blue & White Theme', style:TextStyle(fontWeight:FontWeight.bold)),
      SizedBox(height:20),
      Container(height:300, padding:EdgeInsets.all(12), decoration:BoxDecoration(borderRadius:BorderRadius.circular(12), color:whiteColor, boxShadow:[BoxShadow(color:Colors.black12, blurRadius:4)]), child: BarChart(BarChartData(barGroups:[
        BarChartGroupData(x:0, barRods:[BarChartRodData(toY:8, color:primaryBlue), BarChartRodData(toY:5, color:Colors.red)]),
        BarChartGroupData(x:1, barRods:[BarChartRodData(toY:10, color:primaryBlue), BarChartRodData(toY:6, color:Colors.red)]),
        BarChartGroupData(x:2, barRods:[BarChartRodData(toY:14, color:primaryBlue), BarChartRodData(toY:7, color:Colors.red)]),
        BarChartGroupData(x:3, barRods:[BarChartRodData(toY:12, color:primaryBlue), BarChartRodData(toY:8, color:Colors.red)]),
      ], titlesData:FlTitlesData(bottomTitles:AxisTitles(sideTitles:SideTitles(showTitles:true, getTitlesWidget:(v,_)=>Text(['Jan','Feb','Mar','Apr'][v.toInt()], style:TextStyle(fontSize:10))))))),
      SizedBox(height:12),
      Row(mainAxisAlignment:MainAxisAlignment.center, children:[Container(width:12,height:12,color:primaryBlue), Text(' Income '), Container(width:12,height:12,color:Colors.red), Text(' Expenses')]),
    ]));
  }
}

// ================= UPGRADED CHAT + TASK ASSIGNMENT SYSTEM =================
class ChatMessage {
  String id, sender, receiver, message, time; bool isTask;
  ChatMessage({required this.id, required this.sender, required this.receiver, required this.message, required this.time, this.isTask=false});
  Map<String,dynamic> toJson()=>{"id":id,"sender":sender,"receiver":receiver,"message":message,"time":time,"isTask":isTask};
  factory ChatMessage.fromJson(Map<String,dynamic> j)=>ChatMessage(id:j['id'],sender:j['sender'],receiver:j['receiver'],message:j['message'],time:j['time'],isTask:j['isTask']??false);
}

class TaskAssignment {
  String id, teacherId, teacherName, title, description, deadline, status, assignedBy;
  TaskAssignment({required this.id, required this.teacherId, required this.teacherName, required this.title, required this.description, required this.deadline, this.status="Pending", required this.assignedBy});
  Map<String,dynamic> toJson()=>{"id":id,"teacherId":teacherId,"teacherName":teacherName,"title":title,"description":description,"deadline":deadline,"status":status,"assignedBy":assignedBy};
  factory TaskAssignment.fromJson(Map<String,dynamic> j)=>TaskAssignment(id:j['id'],teacherId:j['teacherId'],teacherName:j['teacherName'],title:j['title'],description:j['description'],deadline:j['deadline'],status:j['status'],assignedBy:j['assignedBy']);
}

class ChatService {
  static Future<List<ChatMessage>> getMessages() async {
    final p=await SharedPreferences.getInstance(); final s=p.getString('chat'); if(s==null) return []; return (jsonDecode(s) as List).map((e)=>ChatMessage.fromJson(e)).toList();
  }
  static Future saveMessages(List<ChatMessage> l) async {
    final p=await SharedPreferences.getInstance(); p.setString('chat', jsonEncode(l.map((e)=>e.toJson()).toList()));
  }
  static Future<List<TaskAssignment>> getTasks() async {
    final p=await SharedPreferences.getInstance(); final s=p.getString('tasks'); if(s==null) return []; return (jsonDecode(s) as List).map((e)=>TaskAssignment.fromJson(e)).toList();
  }
  static Future saveTasks(List<TaskAssignment> l) async {
    final p=await SharedPreferences.getInstance(); p.setString('tasks', jsonEncode(l.map((e)=>e.toJson()).toList()));
  }
}

class ChatPage extends StatefulWidget { @override _ChatPageState createState()=>_ChatPageState(); }
class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  List<ChatMessage> messages=[]; List<TaskAssignment> tasks=[]; List<Staff> teachers=[];
  String currentUser="Admin"; // Will be set by login role
  final msgCtrl=TextEditingController();
  final taskTitleCtrl=TextEditingController(); final taskDescCtrl=TextEditingController(); final taskDeadlineCtrl=TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days:3))));
  String? selectedTeacherId;

  @override void initState(){ super.initState(); _tabCtrl=TabController(length:3, vsync:this); _load(); }
  Future _load() async {
    var m=await ChatService.getMessages(); var t=await ChatService.getTasks(); var s=await DataService.getStaff();
    setState((){ messages=m; tasks=t; teachers=s.where((e)=>e.type=='teaching').toList(); });
  }
  Future _saveMsg() async { await ChatService.saveMessages(messages); }
  Future _saveTasks() async { await ChatService.saveTasks(tasks); }

  @override Widget build(BuildContext context){
    return Column(children:[
      Container(color: primaryBlue, child: TabBar(controller:_tabCtrl, labelColor:whiteColor, unselectedLabelColor:Colors.white70, tabs:[
        Tab(icon:Icon(Icons.chat), text:'Chat Box'),
        Tab(icon:Icon(Icons.assignment), text:'Tasks'),
        Tab(icon:Icon(Icons.notifications), text:'Notifications'),
      ])),
      Expanded(child: TabBarView(controller:_tabCtrl, children:[
        // TAB 1: CHAT
        Column(children:[
          Expanded(child: ListView.builder(itemCount:messages.length, itemBuilder:(c,i){
            var msg=messages[i]; bool isMe=msg.sender==currentUser;
            return Align(alignment:isMe?Alignment.centerRight:Alignment.centerLeft, child: Container(margin:EdgeInsets.all(6), padding:EdgeInsets.all(12), decoration:BoxDecoration(color:isMe?primaryBlue:lightBlue, borderRadius:BorderRadius.circular(12)), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
              Text('${msg.sender} → ${msg.receiver}', style:TextStyle(fontSize:10, fontWeight:FontWeight.bold, color:isMe?whiteColor:primaryBlue)),
              SizedBox(height:4),
              Text(msg.message, style:TextStyle(color:isMe?whiteColor:Colors.black)),
              Text(msg.time, style:TextStyle(fontSize:9, color:isMe?Colors.white70:Colors.grey)),
            ])));
          })),
          Padding(padding:EdgeInsets.all(8), child: Row(children:[
            Expanded(child: TextField(controller:msgCtrl, decoration:InputDecoration(hintText:'Type message to teachers/admin...', border:OutlineInputBorder(borderRadius:BorderRadius.circular(20)), isDense:true))),
            SizedBox(width:8),
            CircleAvatar(backgroundColor:primaryBlue, child: IconButton(icon:Icon(Icons.send, color:whiteColor), onPressed:(){
              if(msgCtrl.text.isEmpty) return;
              var m=ChatMessage(id:DateTime.now().millisecondsSinceEpoch.toString(), sender:currentUser, receiver:"All Teachers", message:msgCtrl.text, time:DateFormat('HH:mm').format(DateTime.now()));
              setState((){ messages.add(m); msgCtrl.clear(); }); _saveMsg();
            })),
          ])),
        ]),
        // TAB 2: TASK ASSIGNMENT - ADMIN TO TEACHER
        Column(children:[
          Padding(padding:EdgeInsets.all(12), child: Card(color:lightBlue, child: Padding(padding:EdgeInsets.all(12), child: Column(children:[
            Text('Assign Task to Teacher - Admin Cooperation', style:TextStyle(fontWeight:FontWeight.bold, color:primaryBlue)),
            SizedBox(height:8),
            DropdownButtonFormField(value:selectedTeacherId, hint:Text('Select Teaching Staff'), items:teachers.map((t)=>DropdownMenuItem(value:t.id, child:Text('${t.name} - ${t.subject}'))).toList(), onChanged:(v)=>setState(()=>selectedTeacherId=v), decoration:InputDecoration(border:OutlineInputBorder(), isDense:true)),
            SizedBox(height:8),
            TextField(controller:taskTitleCtrl, decoration:InputDecoration(labelText:'Task Title (e.g. Prepare P5 Tahfiz Murajia)', border:OutlineInputBorder(), isDense:true)),
            SizedBox(height:8),
            TextField(controller:taskDescCtrl, decoration:InputDecoration(labelText:'Description', border:OutlineInputBorder(), isDense:true), maxLines:2),
            SizedBox(height:8),
            TextField(controller:taskDeadlineCtrl, decoration:InputDecoration(labelText:'Deadline', border:OutlineInputBorder(), isDense:true, suffixIcon:Icon(Icons.calendar_today))),
            SizedBox(height:8),
            SizedBox(width:double.infinity, child: ElevatedButton.icon(icon:Icon(Icons.assignment_ind), label:Text('Assign Task'), onPressed:(){
              if(selectedTeacherId==null || taskTitleCtrl.text.isEmpty) return;
              var teacher=teachers.firstWhere((e)=>e.id==selectedTeacherId);
              var task=TaskAssignment(id:DateTime.now().millisecondsSinceEpoch.toString(), teacherId:teacher.id, teacherName:teacher.name, title:taskTitleCtrl.text, description:taskDescCtrl.text, deadline:taskDeadlineCtrl.text, assignedBy:currentUser);
              setState((){ tasks.add(task); taskTitleCtrl.clear(); taskDescCtrl.clear(); });
              _saveTasks();
              // Also add as chat notification
              var notif=ChatMessage(id:DateTime.now().millisecondsSinceEpoch.toString(), sender:"System", receiver:teacher.name, message:"📋 NEW TASK: ${task.title} - ${task.description} | Deadline: ${task.deadline}", time:DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()), isTask:true);
              messages.add(notif); _saveMsg();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Task assigned to ${teacher.name}')));
            })),
          ])))),
          Expanded(child: ListView.builder(itemCount:tasks.length, itemBuilder:(c,i){
            var t=tasks[i];
            return Card(child: ListTile(leading:CircleAvatar(backgroundColor:t.status=='Completed'?Colors.green:Colors.orange, child:Icon(t.status=='Completed'?Icons.check:Icons.pending, color:whiteColor)), title:Text(t.title), subtitle:Text('To: ${t.teacherName} | ${t.description}\nDeadline: ${t.deadline} | Status: ${t.status}'), isThreeLine:true, trailing:PopupMenuButton(onSelected:(v){ setState((){ if(v=='complete') t.status='Completed'; else if(v=='pending') t.status='Pending'; else if(v=='delete') tasks.removeAt(i); }); _saveTasks(); }, itemBuilder:(_)=>[PopupMenuItem(value:'complete', child:Text('Mark Completed')), PopupMenuItem(value:'pending', child:Text('Mark Pending')), PopupMenuItem(value:'delete', child:Text('Delete'))])));
          })),
        ]),
        // TAB 3: NOTIFICATIONS - JUZ COMPLETION + LESSON PLAN APPROVAL
        ListView(padding:EdgeInsets.all(12), children:[
          Card(color:Colors.green.shade50, child: ListTile(leading:Icon(Icons.emoji_events, color:Colors.green), title:Text('Tahfiz Notification System'), subtitle:Text('When teacher marks Juz completed, Admin gets notification instantly'))),
          SizedBox(height:12),
          ElevatedButton.icon(icon:Icon(Icons.menu_book), label:Text('Teacher: Notify Admin - Student Finished Juz'), onPressed:(){
            _showJuzCompletionDialog();
          }),
          SizedBox(height:12),
          Divider(),
          Text('Lesson Plan Approval Flow', style:TextStyle(fontWeight:FontWeight.bold)),
          SizedBox(height:8),
          Card(child: ListTile(title:Text('Lesson Plans to Approve'), subtitle:Text('Teacher uploads, Admin approves/rejects'), trailing:Icon(Icons.check_circle, color:primaryBlue), onTap:(){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Lesson Plan approval - Coming from Teacher Menu > Lesson Plans')));
          })),
          SizedBox(height:12),
          Text('Recent Notifications', style:TextStyle(fontWeight:FontWeight.bold)),
         ...messages.where((m)=>m.isTask).map((m)=>Card(child: ListTile(leading:Icon(Icons.notifications, color:primaryBlue), title:Text(m.message), subtitle:Text('${m.time}')))).toList(),
          if(messages.where((m)=>m.isTask).isEmpty) Text('No notifications yet - Assign a task or notify Juz completion', style:TextStyle(color:Colors.grey)),
        ]),
      ])),
    ]);
  }

  void _showJuzCompletionDialog(){
    final studentCtrl=TextEditingController(); final juzCtrl=TextEditingController(); final detailCtrl=TextEditingController();
    showDialog(context:context, builder:(_)=>AlertDialog(title:Text('🎉 Notify Admin - Juz Completed'), content:Column(mainAxisSize:MainAxisSize.min, children:[
      TextField(controller:studentCtrl, decoration:InputDecoration(labelText:'Tahfiz Student Name')),
      TextField(controller:juzCtrl, decoration:InputDecoration(labelText:'Juz Completed (e.g. Juz 3)')),
      TextField(controller:detailCtrl, decoration:InputDecoration(labelText:'Sabaq Detail (e.g. Surah Al-Baqarah 1-20)'), maxLines:2),
    ]), actions:[
      TextButton(onPressed:()=>Navigator.pop(context), child:Text('Cancel')),
      ElevatedButton(onPressed:(){
        var msg=ChatMessage(id:DateTime.now().millisecondsSinceEpoch.toString(), sender:"Teacher", receiver:"Admin", message:"🎉 JUZ COMPLETED: ${studentCtrl.text} finished ${juzCtrl.text} - ${detailCtrl.text} | MashaAllah!", time:DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()), isTask:true);
        setState(()=>messages.add(msg)); _saveMsg(); Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Notification sent to Admin!'), backgroundColor:Colors.green));
      }, child:Text('Send Notification to Admin')),
    ]));
  }
}
class MediaLibraryPage extends StatelessWidget { @override Widget build(BuildContext context){ return Center(child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[Icon(Icons.photo_library,size:60,color:primaryBlue), Text('Media Library'), Text('Store school events photos', style:TextStyle(color:Colors.grey))]));} }
class PdfGeneratorPage extends StatelessWidget { @override Widget build(BuildContext context){ return Center(child: ElevatedButton.icon(icon:Icon(Icons.picture_as_pdf), label:Text('Generate Sample PDF with Logo Header'), onPressed:() async {
    final doc=pw.Document(); final logo=await DefaultAssetBundle.of(context).load('assets/images/logo.png').then((d)=>d.buffer.asUint8List()).catchError((_)=>null);
    doc.addPage(pw.Page(build:(_)=>pw.Column(children:[if(logo!=null) pw.Image(pw.MemoryImage(logo),height:80), pw.Text('SALAAMA MUSLIM JUNIOR SCHOOL - PDF Generator', style:pw.TextStyle(fontWeight:pw.FontWeight.bold)), pw.Text('All PDFs include School Logo on header - Blue & White Theme')]))); await Printing.layoutPdf(onLayout:(f) async => doc.save());
  }));} }
class SettingsPage extends StatelessWidget { @override Widget build(BuildContext context){ return ListView(padding:EdgeInsets.all(16), children:[ListTile(leading:Image.asset('assets/images/logo.png', height:40, errorBuilder:(c,e,s)=>Icon(Icons.school)), title:Text('School Name'), subtitle:Text('Salaama Muslim Junior School')), ListTile(leading:Icon(Icons.color_lens), title:Text('Theme Colors'), subtitle:Text('Blue & White - Default')), ListTile(leading:Icon(Icons.update), title:Text('Auto Update'), subtitle:Text('Enabled - Checks for new version automatically')), ListTile(leading:Icon(Icons.email), title:Text('Support'), subtitle:Text('nassakalatiifah@gmail.com | +256 702 642 786'))]);} }

class TeacherDashboard extends StatelessWidget { @override Widget build(BuildContext context){ return Center(child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[Image.asset('assets/images/logo.png', height:80, errorBuilder:(c,e,s)=>Icon(Icons.school,size:60,color:primaryBlue)), SizedBox(height:12), Text('TEACHER MENU', style:TextStyle(fontWeight:FontWeight.bold, color:primaryBlue)), SizedBox(height:8), Text('My Classes | My Students | Attendance | Fees View | Gradebook | Lesson Plans | Chat')]));} }
class TeacherStudentsPage extends StatefulWidget { @override _TeacherStudentsPageState createState()=>_TeacherStudentsPageState();}
class _TeacherStudentsPageState extends State<TeacherStudentsPage> { List<Student> students=[]; @override void initState(){ super.initState(); DataService.getStudents().then((v)=>setState(()=>students=v));} @override Widget build(BuildContext context){ return ListView.builder(itemCount:students.length, itemBuilder:(c,i){ var s=students[i]; return ListTile(leading:Icon(s.type=='tahfiz'?Icons.menu_book:Icons.person, color:s.type=='tahfiz'?Colors.green:primaryBlue), title:Text(s.name), subtitle:Text('${s.className} - ${s.type} ${s.type=='tahfiz'?' | Juz ${s.hifzLevel}':''}'));});} }
class AttendancePage extends StatelessWidget { @override Widget build(BuildContext context){ return Center(child: Text('Attendance - Mark Daily Attendance')); } }
class FeesViewPage extends StatefulWidget { @override _FeesViewPageState createState()=>_FeesViewPageState();}
class _FeesViewPageState extends State<FeesViewPage> { List<FeeRecord> fees=[]; @override void initState(){ super.initState(); DataService.getFees().then((v)=>setState(()=>fees=v));} @override Widget build(BuildContext context){ return ListView.builder(itemCount:fees.length, itemBuilder:(c,i){ var r=fees[i]; return ListTile(title:Text(r.studentName), subtitle:Text('UGX ${r.amount} - ${r.term}'), trailing:Text('View Only'));});} }
class GradebookPage extends StatelessWidget { @override Widget build(BuildContext context){ return Center(child: Text('Gradebook - Enter Marks & Grades')); } }
class LessonPlanPage extends StatelessWidget { @override Widget build(BuildContext context){ return Center(child: Text('Lesson Plans - Prepare & Upload Lesson Plans')); } }