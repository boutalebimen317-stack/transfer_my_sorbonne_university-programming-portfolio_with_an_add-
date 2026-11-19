
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const StudentCompanion());
}

class StudentCompanion extends StatelessWidget {
  const StudentCompanion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6558D3),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F5FB),
      ),
      home: const HomePage(),
    );
  }
}

class Assignment {
  String title;
  String subject;
  DateTime deadline;
  bool completed;

  Assignment({
    required this.title,
    required this.subject,
    required this.deadline,
    this.completed = false,
  });
}

class StudyNote {
  String title;
  String content;

  StudyNote({
    required this.title,
    required this.content,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 0;

  final List<Assignment> assignments = [
    Assignment(
      title: 'Finish programming exercises',
      subject: 'Algorithms',
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    Assignment(
      title: 'Review chapter 3',
      subject: 'Mathematics',
      deadline: DateTime.now().add(const Duration(days: 2)),
    ),
    Assignment(
      title: 'Prepare electronics summary',
      subject: 'Electronics',
      deadline: DateTime.now().add(const Duration(days: 4)),
      completed: true,
    ),
  ];

  final List<StudyNote> notes = [
    StudyNote(
      title: 'Programming',
      content: 'Remember to practise functions and arrays.',
    ),
    StudyNote(
      title: 'Mathematics',
      content: 'Review derivatives and important formulas.',
    ),
  ];

  final List<Map<String, String>> schedule = [
    {'day': 'Sunday', 'time': '08:00 - 10:00', 'subject': 'Algorithms'},
    {'day': 'Sunday', 'time': '10:00 - 12:00', 'subject': 'Mathematics'},
    {'day': 'Monday', 'time': '08:00 - 10:00', 'subject': 'Architecture'},
    {'day': 'Monday', 'time': '13:00 - 15:00', 'subject': 'Electronics'},
    {'day': 'Tuesday', 'time': '09:00 - 11:00', 'subject': 'Analysis'},
    {'day': 'Wednesday', 'time': '10:00 - 12:00', 'subject': 'Operating Systems'},
  ];

  int get completedCount =>
      assignments.where((item) => item.completed).length;

  void toggleAssignment(Assignment assignment) {
    setState(() {
      assignment.completed = !assignment.completed;
    });
  }

  void addAssignment() {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    DateTime deadline = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, updateDialog) {
            return AlertDialog(
              title: const Text('New assignment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Assignment title',
                      ),
                    ),
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                      ),
                    ),
                    const SizedBox(height: 15),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: dialogContext,
                          initialDate: deadline,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );

                        if (picked != null) {
                          updateDialog(() {
                            deadline = picked;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: Text(
                        '${deadline.day}/${deadline.month}/${deadline.year}',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty ||
                        subjectController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      assignments.add(
                        Assignment(
                          title: titleController.text.trim(),
                          subject: subjectController.text.trim(),
                          deadline: deadline,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addNote() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create a note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Note title',
                  ),
                ),
                TextField(
                  controller: contentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Write your note',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty ||
                    contentController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  notes.add(
                    StudyNote(
                      title: titleController.text.trim(),
                      content: contentController.text.trim(),
                    ),
                  );
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget dashboardPage() {
    final pending = assignments.length - completedCount;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Hello, Student!',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          'Here is your study overview.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 25),

        Row(
          children: [
            Expanded(
              child: summaryCard(
                'Assignments',
                '${assignments.length}',
                Icons.assignment_outlined,
                Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: summaryCard(
                'Completed',
                '$completedCount',
                Icons.check_circle_outline,
                Colors.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: summaryCard(
                'Pending',
                '$pending',
                Icons.pending_actions,
                Colors.orange,
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),
        sectionTitle('Upcoming assignments'),

        if (assignments.isEmpty)
          const Text('No assignments yet.')
        else
          ...assignments
              .where((item) => !item.completed)
              .take(3)
              .map((item) => assignmentCard(item)),

        const SizedBox(height: 25),
        sectionTitle('Quick actions'),

        Row(
          children: [
            Expanded(
              child: quickAction(
                Icons.add_task,
                'Add assignment',
                addAssignment,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: quickAction(
                Icons.note_add_outlined,
                'New note',
                addNote,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget summaryCard(
    String title,
    String number,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 12),
          Text(
            number,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget assignmentCard(Assignment assignment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      child: ListTile(
        leading: Checkbox(
          value: assignment.completed,
          onChanged: (_) => toggleAssignment(assignment),
        ),
        title: Text(
          assignment.title,
          style: TextStyle(
            decoration: assignment.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          '${assignment.subject} • Due ${assignment.deadline.day}/${assignment.deadline.month}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            setState(() {
              assignments.remove(assignment);
            });
          },
        ),
      ),
    );
  }

  Widget quickAction(
    IconData icon,
    String title,
    VoidCallback action,
  ) {
    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget assignmentsPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'My Assignments',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: addAssignment,
          icon: const Icon(Icons.add),
          label: const Text('Add assignment'),
        ),
        const SizedBox(height: 20),
        if (assignments.isEmpty)
          const Center(child: Text('No assignments available.')),
        ...assignments.map((item) => assignmentCard(item)),
      ],
    );
  }

  Widget schedulePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Weekly Timetable',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ...schedule.map((lesson) {
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.school_outlined),
              ),
              title: Text(lesson['subject']!),
              subtitle: Text(lesson['day']!),
              trailing: Text(
                lesson['time']!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget notesPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'My Notes',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: addNote,
          icon: const Icon(Icons.add),
          label: const Text('Create note'),
        ),
        const SizedBox(height: 20),
        if (notes.isEmpty)
          const Center(child: Text('No notes yet.')),
        ...notes.map((note) {
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.sticky_note_2_outlined,
                color: Colors.deepPurple,
              ),
              title: Text(note.title),
              subtitle: Text(note.content),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  setState(() {
                    notes.remove(note);
                  });
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      dashboardPage(),
      assignmentsPage(),
      schedulePage(),
      notesPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Companion',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You are all caught up!'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: pages[selectedPage],
      floatingActionButton: selectedPage == 0
          ? FloatingActionButton(
              onPressed: addAssignment,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPage,
        onDestinationSelected: (index) {
          setState(() {
            selectedPage = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            label: 'Notes',
          ),
        ],
      ),
    );
  }
}
