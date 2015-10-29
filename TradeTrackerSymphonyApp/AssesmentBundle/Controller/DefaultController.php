<?php

namespace TradeTracker\AssesmentBundle\Controller;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use TradeTracker\AssesmentBundle\Entity\MyUser;

class DefaultController extends Controller
{
    public function indexAction()
    {
        return $this->render('TradeTrackerAssesmentBundle:Default:index.html.twig');
    }

    public function transferAction()
    {
        $repository = $this->getDoctrine()->getManager()->getRepository('TradeTrackerAssesmentBundle:MyUser');
        $users = $repository->findAll();
        foreach($users as $key=>$user){
            $first_name = $user->getFirstName();
            $last_name = $user->getLastName();
            $age = $user->getAge();
            $remove = $key ==0 ? 'remove' : null;
            $statement= "php ../src/TradeTracker/AssesmentBundle/Controller/transfer.php {$first_name} {$last_name} {$age} {$remove}";
            exec($statement);
        }
        return $this->render('TradeTrackerAssesmentBundle:Default:transfer.html.twig');
    }

    public function testAction(){
        $user = new MyUser();
        $first_names = array('ABC', 'DEF', 'GHI', 'JK', 'ST', 'XYZ');
        $last_names = array('CBA', 'FED', 'IHG', 'KJ', 'TS', 'ZYX');
        $first_name_number = rand(0, 5);
        $last_name_number = rand(0, 5);
        $age = rand(1, 100);
        $first_name = $first_names[$first_name_number] . ($age + $last_name_number);
        $last_name = $last_names[$last_name_number] . ($age + $first_name_number); 
        $user->setFirstName($first_name);
        $user->setLastName($last_name);
        $user->setAge($age);
        $em = $this->getDoctrine()->getManager();
        $em->persist($user);
        $em->flush();
        $repo = $this->getDoctrine()->getManager()->getRepository('TradeTrackerAssesmentBundle:MyUser');
        $qb = $repo->createQueryBuilder('m');
        $qb->select('COUNT(m)');
        $count = $qb->getQuery()->getSingleScalarResult();
        return  $this->render('TradeTrackerAssesmentBundle:Default:test.html.twig', array('first_name' => $first_name, 'last_name' => $last_name, 'age' => $age,'count'=>$count));
    }

    public function countAction(){
        $count = exec("php ../src/TradeTracker/AssesmentBundle/Controller/count.php");
        return $this->render('TradeTrackerAssesmentBundle:Default:count.html.twig',array('count'=>$count));
    }

    public function takedownAction()
    {
        $check_running = shell_exec('/usr/local/bin/aws ec2 describe-instance-status --instance-ids i-7a164fae --filters --region us-east-1 --output text | awk \'/INSTANCESTATE/ {print $3}\' | tr -d \'\n\'');
        if ($check_running == "running") {
            $msg = "Instance is Running!!Stopping!!";
            shell_exec('/usr/local/bin/aws ec2 stop-instances --instance-ids i-7a164fae --output text --region us-east-1');
        } else {
            $msg = "Instance is not Running!!";
        }
            return $this->render('TradeTrackerAssesmentBundle:Default:takedown.html.twig',array('check_running'=>$check_running,'msg'=>$msg));
    }

    public function setupAction()
    {
        $elb = shell_exec('/usr/local/bin/aws elb describe-load-balancers --region us-east-1 --output text | /usr/bin/awk \'/LOADBALANCERDESCRIPTIONS/ {print $2}\' | /usr/bin/tr -d \'\n\'');
        $status = shell_exec('/usr/local/bin/aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names tradetracker-assesment --region us-east-1 | /usr/bin/awk \'/MinSize/ {print $2}\'| tr -d \',\'');
        if ($status > 0) {
            $msg = "Infrastruture is already Created!!";
            $msg1 = "You can test the App using the Below URL";
        } else {
            $msg = "Creating Infrastructure.......";
            shell_exec('/usr/local/bin/aws autoscaling update-auto-scaling-group --auto-scaling-group-name tradetracker-assesment --min-size 2 --max-size 6 --launch-configuration-name tradetracker-assesment-lc --region us-east-1 --output text');
            $msg1 = "Wait for few minutes and then use the below url for Testing.";

        }
            return $this->render('TradeTrackerAssesmentBundle:Default:setup.html.twig', array('elb' => $elb, 'msg' => $msg, 'msg1' => $msg1));
    }

    public function teardownAction()
    {
        $status = shell_exec('/usr/local/bin/aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names tradetracker-assesment --region us-east-1 | /usr/bin/awk \'/MinSize/ {print $2}\'| tr -d \',\'');
        if ($status > 0) {
            $msg = "Destroying the Infrastructure which is created for Testing the App!!";
            shell_exec('/usr/local/bin/aws autoscaling update-auto-scaling-group --auto-scaling-group-name tradetracker-assesment --min-size 0 --max-size 0 --launch-configuration-name tradetracker-assesment-lc --region us-east-1 --output text');
            $elb = shell_exec('/usr/local/bin/aws elb describe-load-balancers --region us-east-1 --output text | /usr/bin/awk \'/LOADBALANCERDESCRIPTIONS/ {print $2}\' | /usr/bin/tr -d \'\n\'');
        } else {
            $msg = "Infrastruture is not running!!";
        }
            return $this->render('TradeTrackerAssesmentBundle:Default:teardown.html.twig', array('msg' => $msg));

    }
}
