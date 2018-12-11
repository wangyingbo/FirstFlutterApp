
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() => runApp(MyApp());//main函数使用了(=>)符号, 这是Dart中单行函数或方法的简写。

//Stateless widgets 是不可变的, 这意味着它们的属性不能改变 - 所有的值都是最终的.Stateful widgets 持有的状态可能在widget生命周期中发生变化. 实现一个 stateful widget 至少需要两个类:一个 StatefulWidget类。一个 State类。 StatefulWidget类本身是不变的，但是 State类在widget生命周期中始终存在.
class MyApp extends StatelessWidget {//该应用程序继承了 StatelessWidget，这将会使应用本身也成为一个widget。 在Flutter中，大多数东西都是widget，包括对齐(alignment)、填充(padding)和布局(layout)
  @override
  Widget build(BuildContext context) {//widget的主要工作是提供一个build()方法来描述如何根据其他较低级别的widget来显示自己。

  //单词对是在 build 方法内部生成的。每次MaterialApp需要渲染时或者在Flutter Inspector中切换平台时 build 都会运行.
  //final myWordPair = new WordPair.random();//生成随机单词
    return new MaterialApp(//建一个Material APP。Material是一种标准的移动端和web端的视觉设计语言。 Flutter提供了一套丰富的Material widgets
      title: '欢迎你，第一个flutter App',
      // home: new Scaffold(//Scaffold 是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性。widget树可以很复杂。
      //   appBar: new AppBar(
      //     title: new Text('欢迎欢迎，热烈欢迎'),
      //   ),
      //   body: new Center(//本示例中的body的widget树中包含了一个Center widget, Center widget又包含一个 Text 子widget。 Center widget可以将其子widget树对其到屏幕中心。
      //     //child: new Text('hello world'),
      //     //child: new Text(myWordPair.asPascalCase),
      //     child: new RandomWords(),
      //   ),
      // ),
      theme: new ThemeData(//主题色
        primaryColor: Colors.white,
      ),
      home: new RandomWords(),
    );
  }
}


///创建RandomWords类来管理生成单词的代码
class RandomWords extends StatefulWidget {
  @override
  //createState() => new RandomWordsState();//使用了(=>)符号, 这是Dart中单行函数或方法的简写，等同于下面的写法；
  State<StatefulWidget> createState() {
      return new RandomWordsState();
    }
}

///创建RandomWordsState类负责生成listView
class RandomWordsState extends State<RandomWords> {

  //在Dart语言中使用下划线前缀标识符，会强制其变成私有的。
  //继承自StatelessComponent的组件，如内部有配置，属性或状态的统一需要使用final修饰符，表示这个组件本身自己是无状态的，需要依赖它外部的其他组件。这也是'组件外构建UI'最重要的含义所在。
  //无状态组件，即继承自StatelessComponent的组件。它们的特点就是自己内部的配置属性都使用final修饰符，强制其自身无法修改自身状态。
  final _suggestions = <WordPair>[];
  final _bigFont = const TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();

  @override
    void initState() {
      super.initState();
      for (var i = 0; i < 60; i++) {
        WordPair pair = new WordPair.random();
        _suggestions.add(pair);
      }
    }

  @override
    Widget build(BuildContext context) {
      //final myWordPair = new WordPair.random();
      //return new Text(myWordPair.asPascalCase);
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Startup Name Generator'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.list),
              onPressed: _pushSaved,
            ),
          ],
        ),
        body: _buildSuggestions(),
      );
    }

  /// 路由跳转
  void _pushSaved () {
    Navigator.of(context).push(//添加Navigator.push调用，这会使路由入栈（以后路由入栈均指推入到导航管理器的栈）
      new MaterialPageRoute(//当用户点击导航栏中的列表图标时，建立一个路由并将其推入到导航管理器栈中。此操作会切换页面以显示新路由。
        builder: (context) {//新页面的内容在在MaterialPageRoute的builder属性中构建，builder是一个匿名函数
          final _tile = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style:_bigFont,
                ),
              );
            },
          );

          final divided = ListTile.divideTiles(
            context: context,
            tiles: _tile,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('saved suggestions'),
            ),
            body: new ListView(
              children: divided,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions () {
    return new ListView.builder(
      itemCount: _suggestions.length,
      padding: EdgeInsets.all(14.0),

      // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
      // 在偶数行，该函数会为单词对添加一个ListTile row.
      // 在奇数行，该行书湖添加一个分割线widget，来分隔相邻的词对。
      // 注意，在小屏幕上，分割线看起来可能比较吃力。
      //ListView类提供了一个builder属性，itemBuilder 值是一个匿名回调函数， 接受两个参数- BuildContext和行迭代器i。迭代器从0开始， 每调用一次该函数，i就会自增1，对于每个建议的单词对都会执行一次。该模型允许建议的单词对列表在用户滚动时无限增长。
      itemBuilder: (context, i) {
        // 在每一列之前，添加一个1像素高的分隔线widget
        if (i.isOdd) {//奇数
          return new Divider();
        }

        // // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
        // // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
        // final index = i ~/ 2;
        // // 如果是建议列表中最后一个单词对
        // if (index >= _suggestions.length) {
        //   // ...接着再生成10个单词对，然后添加到建议列表
        //   _suggestions.addAll(generateWordPairs().take(10));// 无限加载逻辑
        // }

        //对于每一个单词对，_buildSuggestions函数都会调用一次_buildRow。 这个函数在ListTile中显示每个新词对，这使您在下一步中可以生成更漂亮的显示行
        return _buildRow(_suggestions[i]);
      },

    );
  }

  Widget _buildRow (WordPair pair) {
    //是否已经被收藏
    final _alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _bigFont,
      ),
      trailing: new Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        //函数调用setState()通知框架状态已经改变
        setState(() {
                  if (_alreadySaved) {
                    _saved.remove(pair);
                  }else {
                    _saved.add(pair);
                  }
                });
      },
    );
  }
}








 /**   官方demo代码
  
  class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

  */